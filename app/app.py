from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
from datetime import datetime, timezone
from constant import *
import os
import time
import warnings
import numpy as np
import torch
import cv2
import logging
import tempfile
import librosa
from collections import deque
from supabase import create_client, Client
import uuid
from dotenv import load_dotenv
from model.utils.Model import MultimodalAttentionLSTMClassifier
from model.utils.VideoExtractor import VideoExtractor
from model.utils.AudioExtractor import AudioExtractor
from model.utils.TextExtractor import TextExtractor
from model.utils.FusionExtractor import FusionExtractor

load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")
SUPABASE_BUCKET = os.getenv("SUPABASE_BUCKET")
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# constants for model
WINDOW_CONTEXT = 5
MODEL_PATH      = "model/utils/deception_model.pth"
FACE_MARKER     = "model/utils/face_landmarker.task"
CODE2LABEL      = {"PT":0,"NL":0,"PL":1,"NT":1}

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})
logging.basicConfig(level=logging.INFO)
log = logging.getLogger("api")

def now_utc() -> str:
    return datetime.now(timezone.utc).isoformat()

def ok(payload, code=200):
    return jsonify(payload), code

@app.post("/sessions")
def start_session():
    data = request.form

    try:
        existing = supabase.table("analyzed_subject") \
            .select("id") \
            .eq("user_id", data["user_id"]) \
            .eq("name", data["name"]) \
            .eq("identification_no", data["id_no"]) \
            .execute()

        session_number = len(existing.data) + 1
        session_id = f"{data['user_id']}--{data['name']}--{data['id_no']}-{session_number}"
    except Exception as e:
        log.error("Failed to get session number", exc_info=True)
        return ok({"error": "DB query failed"}, 500)

    try:
        supabase.table("analyzed_subject").insert({
            "user_id": data["user_id"],
            "name":  data["name"],
            "identification_no": data["id_no"],
            "session_number": session_number,
            "session_id": session_id,
            "created_at": now_utc()
        }).execute()
    except Exception as e:
        log.error("Failed to create session", exc_info=True)
        return ok({"error": "DB insert failed"}, 500)

    return ok({"session_id": session_id}, 201)

@app.post("/sessions/<session_id>/chunk")
def predict_chunk(session_id):
    if "media" not in request.files:
        return ok({"error": "media file missing"}, 400)
    # Run Prediction
    result = run_single_prediction_from_filestorage(request.files["media"])
    # Get subject metadata
    subject_query = supabase.table("analyzed_subject") \
        .select("id", "user_id") \
        .eq("session_id", session_id) \
        .execute()
    if not subject_query.data:
        return ok({"error": "Session not found"}, 404)
    subject = subject_query.data[0]
    subject_id = subject["id"]
    user_id = subject["user_id"]
    # Upload chunk to private Supabase bucket
    file = request.files["media"]
    filename = f"{session_id}_{int(time.time() * 1000)}.webm"
    file_path = f"chunks/{filename}"
    file_bytes = file.read()
    supabase.storage.from_(SUPABASE_BUCKET).upload(
        file_path, file_bytes, {"content-type": "video/webm"}
    )
    # generate signed URL to preview (not stored unless needed)
    signed_url_resp = supabase.storage.from_(SUPABASE_BUCKET).create_signed_url(file_path, expires_in=3600)
    signed_url = signed_url_resp.get("signedURL")
    # Get chunk frame index using count
    chunk_count_result = supabase.table("session_video") \
        .select("id", count="exact") \
        .eq("session_id", session_id) \
        .execute()
    frame_index = chunk_count_result.count + 1
    # Store chunk metadata
    supabase.table("session_video").insert({
        "user_id": user_id,
        "subject_id": subject_id,
        "session_id": session_id,
        "chunk_url": file_path,  
        "frame_index": frame_index,
        "created_at": now_utc()
    }).execute()
    return ok({**result, "signed_url": signed_url})

@app.post("/sessions/<session_id>/end")
def end_session(session_id):
    final_prob = request.form.get("final_prob")
    
    try:
        final_prob = float(final_prob)
    except (TypeError, ValueError):
        final_prob = None  # fallback to null in Supabase

    supabase.table("analyzed_subject").update({
        "final_label": request.form.get("final_label"),
        "final_prob":  final_prob,
        "ended_at":    now_utc()
    }).eq("session_id", session_id).execute()

    return ok({"status": "session closed"})

def run_single_prediction_from_filestorage(file_storage):
    """
    1) Save incoming FileStorage (.webm)
    2) Extract exactly one window via FusionExtractor
    3) Run the model once and return a single (window_idx, prob, label)
    """
    # --- 1) Save to temp file ---
    tmp = tempfile.NamedTemporaryFile(suffix=".webm", delete=False)
    tmp_path = tmp.name
    file_storage.save(tmp_path)
    tmp.close()

    # --- 2) Extract fusion for one window ---
    fusion = FusionExtractor(model_path=FACE_MARKER, window_size=1.0, log_path="/dev/null")
    fusion.extract_without_save(video_path=tmp_path)
    fused = fusion.get_results()
    os.remove(tmp_path)

    if len(fused) != 1:
        raise ValueError(f"Expected exactly 1 window, but got {len(fused)}")

    w = fused[0]
    Fv, Fa, Ft = len(w["video"]), len(w["audio"]), len(w["text"])
    total_F = Fv + Fa + Ft

    # --- 3) Load and run model once ---
    model = MultimodalAttentionLSTMClassifier(
        len(w["video"]), len(w["audio"]), len(w["text"])
    )
    ckpt = torch.load(MODEL_PATH, map_location="cpu")
    model.load_state_dict(ckpt)
    model.eval()

    # 1) concatenate into one 1-D array
    features = np.concatenate([w["video"], w["audio"], w["text"]])  # shape (total_F,)

    # 2) turn into torch, and reshape into (batch=1, seq_len=1, features=total_F)
    seq = torch.tensor(features, dtype=torch.float32).view(1, 1, total_F)

    # 3) split into three modality tensors, each 3-D
    v_seq = seq[:, :, :Fv]  # shape (1, 1, Fv)
    a_seq = seq[:, :, Fv:Fv + Fa]  # shape (1, 1, Fa)
    t_seq = seq[:, :, Fv + Fa:]
    with torch.no_grad():
        out   = model(v_seq, a_seq, t_seq)               # expects (1,1, F) → (1,1) or similar
        prob  = torch.sigmoid(out).item()
        label = "🟥 LIE" if prob < 0.5 else "🟩 TRUTH"

    return {
        "window": w["window"],
        "prob":   prob,
        "label":  label
    }

if __name__ == '__main__':
    log.info("Starting Deception Detection API")
    app.run(host='0.0.0.0', port=5050)


import unittest

# class ExtractWithoutSaveTest(unittest.TestCase):
#
#     def test_extract_without_save(self):
#         video_path = "/private/var/folders/xc/m4jrww5902x6k0_qk1rny24r0000gn/T/tmp9hy0kuq_.webm"
#         fusion_extractor = FusionExtractor()
#         fusion_extractor.extract_without_save(video_path=video_path)
#         result = fusion_extractor.get_results()[0]
#         self.assertNotEquals(result["video"], [])
#         self.assertNotEquals(result["video"][0], 0.0)
#         self.assertNotEquals(result["audio"], [])
#         self.assertNotEquals(result["audio"][0], 0.0)
#         self.assertNotEquals(result["text"], [])
#         self.assertNotEquals(result["text"][0], 0.0)
#
# def get_filestorage_from_path(file_path, filename=None, content_type='video/webm'):
#     return FileStorage(
#         stream=open(file_path, 'rb'),
#         filename=filename or file_path.split('/')[-1],
#         content_type=content_type
#     )
# class RunOnePredictionFromFileStorageTest(unittest.TestCase):
#     def test_run_one_prediction_from_file_storage(self):
#         video_path = "/private/var/folders/xc/m4jrww5902x6k0_qk1rny24r0000gn/T/tmp9hy0kuq_.webm"
#         file_storage = get_filestorage_from_path(video_path)
#
#         result = run_single_prediction_from_filestorage(file_storage)
#         label = result["label"]
#
#         self.assertTrue(label == "🟩 TRUTH" or label == "🟥 LIE")
@app.post("/sessions/<session_id>/chunk")
def predict_chunk(session_id):
    if "media" not in request.files:
        return ok({"error": "media file missing"}, 400)  # Error handling for missing media file (Usability)
    # Run the prediction function on the uploaded file (Real-time processing)
    result = run_single_prediction_from_filestorage(request.files["media"])

    # Fetch metadata from the database for the given session (Database Integration)
    subject_query = supabase.table("analyzed_subject") \
        .select("id", "user_id") \
        .eq("session_id", session_id) \
        .execute()
    if not subject_query.data:
        return ok({"error": "Session not found"}, 404)  # Handle missing session in the database (Robustness)
    subject = subject_query.data[0]
    subject_id = subject["id"]
    user_id = subject["user_id"]

    # Upload the chunk video file to Supabase storage (secure, private) (Data Storage)
    file = request.files["media"]
    filename = f"{session_id}_{int(time.time() * 1000)}.webm"
    file_path = f"chunks/{filename}"
    file_bytes = file.read()
    supabase.storage.from_(SUPABASE_BUCKET).upload(
        file_path, file_bytes, {"content-type": "video/webm"}
    )

    # Generate a signed URL for temporary access to the uploaded file (Security)
    signed_url_resp = supabase.storage.from_(SUPABASE_BUCKET).create_signed_url(file_path, expires_in=3600)
    signed_url = signed_url_resp.get("signedURL")
    # Calculate chunk frame index using count from the database (Database Integration)
    chunk_count_result = supabase.table("session_video") \
        .select("id", count="exact") \
        .eq("session_id", session_id) \
        .execute()
    frame_index = chunk_count_result.count + 1

    # Store metadata of the chunk in the database for further processing (Data Storage, Scalability)
    supabase.table("session_video").insert({
        "user_id": user_id,
        "subject_id": subject_id,
        "session_id": session_id,
        "chunk_url": file_path,
        "frame_index": frame_index,
        "created_at": now_utc()  # Timestamp for when the chunk was uploaded
    }).execute()

    return ok({**result, "signed_url": signed_url})  # Return prediction result and signed URL (Usability)


def run_single_prediction_from_filestorage(file_storage):
    # 1) Temp file to store uploaded media (Portability)
    tmp = tempfile.NamedTemporaryFile(suffix=".webm", delete=False)
    tmp_path = tmp.name
    file_storage.save(tmp_path)
    tmp.close()

    # 2) Extract features without saving intermediate steps (Feature Extraction)
    fusion = FusionExtractor(model_path=FACE_MARKER, window_size=1.0, log_path="/dev/null")
    fusion.extract_without_save(video_path=tmp_path)  # fused = fusion.get_results()
    os.remove(tmp_path)  # Remove temp file after processing (Portability)
    if len(fused) != 1:  # Ensure only one window is processed (Robustness)
        raise ValueError(f"Expected exactly 1 window, but got {len(fused)}")
    w = fused[0]
    Fv, Fa, Ft = len(w["video"]), len(w["audio"]), len(w["text"])
    total_F = Fv + Fa + Ft

    # 3)Initialize the multimodal model (Software Requirements)
    model = MultimodalAttentionLSTMClassifier(Fv, Fa, Ft)
    ckpt = torch.load(MODEL_PATH, map_location="cpu")  # Load the pre-trained model weights (Model Reusability)
    model.load_state_dict(ckpt)
    model.eval()  # Set model to evaluation mode (Efficiency)
    features = np.concatenate([w["video"], w["audio"], w["text"]])
    seq = torch.tensor(features, dtype=torch.float32).view(1, 1, total_F)
    v_seq = seq[:, :, :Fv]  # Video sequence tensor
    a_seq = seq[:, :, Fv:Fv + Fa]  # Audio sequence tensor
    t_seq = seq[:, :, Fv + Fa:]  # Text sequence tensor
    with torch.no_grad():
        out = model(v_seq, a_seq, t_seq)  # Perform inference (Real-time Prediction)
        prob = torch.sigmoid(out).item()  # Get probability of deception
        label = "🟥 LIE" if prob < 0.5 else "🟩 TRUTH"  # Classify result (Model Classification)

    return {"window": w["window"], "prob": prob,
            "label": label}  # Return prediction result (Usability, Real-time Processing)