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

# Import your multimodal model and extractors
from Model import MultimodalAttentionLSTMClassifier
from VideoExtractor import VideoExtractor
from AudioExtractor import AudioExtractor
from TextExtractor import TextExtractor
from FusionExtractor import FusionExtractor

# Suppress unwanted logs
os.environ["GLOG_minloglevel"] = "3"
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
os.environ["TOKENIZERS_PARALLELISM"] = "false"
warnings.filterwarnings("ignore", message="FP16 is not supported on CPU; using FP32 instead")

# Setup logging
logging.basicConfig(
    filename="./realtime.log",
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    filemode='w'
)

# Audio parameters
RATE = 22050           # audio sample rate
WINDOW_SIZE = RATE      # 1-second window
CHUNK_SIZE = 1024       # small audio chunks for streaming

# Initialize extractors and model
audio_extractor = AudioExtractor()
video_extractor = VideoExtractor("../face_landmarker.task")
text_extractor = TextExtractor()
fusion_extractor = FusionExtractor()

# Load the trained multimodal model
dim_video, dim_audio, dim_text = 1434, 6732, 778
model = MultimodalAttentionLSTMClassifier(dim_video, dim_audio, dim_text)
model.load_state_dict(torch.load("deception_model.pth", map_location=torch.device('cpu')))
model.eval()

# Context buffers for sliding prediction
video_context = deque(maxlen=5)
audio_context = deque(maxlen=5)
text_context = deque(maxlen=5)


def run_realtime_from_filestorage(file_storage):
    """
    Processes a WebM file-like object (Flask FileStorage or similar) for real-time fusion and prediction.
    """
    # 1) Save to temporary file
    tmp = tempfile.NamedTemporaryFile(suffix='.webm', delete=False)
    file_path = tmp.name
    file_storage.save(file_path)
    tmp.close()

    # 2) Load audio fully for chunk streaming
    audio_samples, _ = librosa.load(file_path, sr=RATE)
    current_audio_idx = 0

    def get_next_audio_chunk(size):
        nonlocal current_audio_idx
        if current_audio_idx >= len(audio_samples):
            return None
        end = current_audio_idx + size
        chunk = audio_samples[current_audio_idx:end]
        current_audio_idx = end
        return chunk

    # 3) Open video for frame streaming
    cap = cv2.VideoCapture(file_path)
    fps = cap.get(cv2.CAP_PROP_FPS) or 30
    frame_interval = 1.0 / fps
    frames_per_window = int(fps)

    frame_landmarks = []
    audio_buffer = np.array([], dtype=np.float32)
    last_time = time.time()

    try:
        while True:
            # Read next video frame
            ret, frame = cap.read()
            if not ret:
                break
            vec = video_extractor.get_landmarks_from_frame(frame)
            if vec is not None:
                frame_landmarks.append(vec)

            # Display (optional)
            cv2.imshow("Playback", frame)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

            # Read next audio chunk
            chunk = get_next_audio_chunk(CHUNK_SIZE)
            if chunk is None:
                break
            audio_buffer = np.append(audio_buffer, chunk)

            # Process once per second
            now = time.time()
            if now - last_time < 1.0:
                time.sleep(frame_interval)
                continue
            last_time = now

            # Ensure enough data
            if len(audio_buffer) >= WINDOW_SIZE and len(frame_landmarks) >= frames_per_window:
                # Audio features
                audio_window = audio_buffer[:WINDOW_SIZE]
                audio_buffer = audio_buffer[WINDOW_SIZE:]
                audio_feat = audio_extractor.get_features_from_window(audio_window)

                # Text features
                text_feat, transcript = text_extractor.extract_features_from_audio_window(audio_window)

                # Video features
                avg_landmark = np.mean(frame_landmarks, axis=0)
                frame_landmarks = []

                # Update contexts
                video_context.append(avg_landmark)
                audio_context.append(audio_feat)
                text_context.append(text_feat)

                # Predict when contexts full
                if len(video_context) == 5:
                    v_seq = torch.tensor(np.array(video_context), dtype=torch.float32).unsqueeze(0)
                    a_seq = torch.tensor(np.array(audio_context), dtype=torch.float32).unsqueeze(0)
                    t_seq = torch.tensor(np.array(text_context), dtype=torch.float32).unsqueeze(0)

                    with torch.no_grad():
                        out = model(v_seq, a_seq, t_seq)
                        prob = torch.sigmoid(out).item()
                        label = '🟥 LIE' if prob > 0.5 else '🟩 TRUTH'

                    msg = f"Prediction: {label} (Score={prob:.3f}) Transcript: {transcript}"
                    print(msg)
                    logging.info(msg)

            time.sleep(frame_interval)

    except KeyboardInterrupt:
        print("Interrupted")
    finally:
        cap.release()
        cv2.destroyAllWindows()
        os.remove(file_path)

# Example usage:
# from flask import request
# file_storage = request.files['video']
# run_realtime_from_filestorage(file_storage)
