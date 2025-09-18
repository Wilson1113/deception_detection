import os
import time

import math
import torch
import ffmpeg
import spacy
import whisper
import pickle
from transformers import AutoTokenizer, AutoModel, pipeline
import numpy as np
import soundfile as sf

# Load models once globally (if acceptable)
nlp = spacy.load("en_core_web_sm")
tokenizer_bert = AutoTokenizer.from_pretrained("distilbert-base-uncased")
model_bert = AutoModel.from_pretrained("distilbert-base-uncased")
sentiment_analyzer = pipeline("sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english")

# Lexicons
NEGATIONS = {"no", "not", "never", "none", "nothing", "nobody", "neither", "nor"}
COGNITIVE = {"think", "know", "consider", "believe", "realize", "guess"}
AFFECTIVE = {"love", "hate", "happy", "sad", "angry", "fear"}
FILLERS = {"um", "uh", "uhm", "er", "ah", "uh-huh", "like"}


class TextExtractor:
    def __init__(self, whisper_model="base", window_size=1.0):
        self.whisper_model = whisper_model
        self.window_size = window_size
        self.features = []

    def extract_audio_from_wmv(self, input_wmv, output_wav):
        ffmpeg.input(input_wmv).output(
            output_wav, format='wav', acodec='pcm_s16le', ac=1, ar='16000'
        ).overwrite_output().run()
        print(f"[INFO] Audio extracted to: {output_wav}")

    def transcribe(self, wav_path):
        print(f"[INFO] Loading Whisper model: {self.whisper_model}")
        model = whisper.load_model(self.whisper_model)
        print("[INFO] Transcribing with Whisper...")
        result = model.transcribe(wav_path, task="transcribe", language="en")
        return result["segments"]

    def chunk_text_by_time(self, segments, total_duration):
        n_windows = int(math.ceil(total_duration / self.window_size))
        chunked = []
        for i in range(n_windows):
            w_start = i * self.window_size
            w_end = min((i + 1) * self.window_size, total_duration)
            texts = [seg["text"] for seg in segments if seg["end"] > w_start and seg["start"] < w_end]
            combined = " ".join(texts).strip()
            chunked.append((w_start, w_end, combined))
        return chunked

    def get_contextual_embedding(self, text):
        if not text.strip():
            return torch.zeros(768)
        inputs = tokenizer_bert(text, return_tensors="pt", truncation=True, max_length=512)
        with torch.no_grad():
            outputs = model_bert(**inputs)
        return outputs.last_hidden_state.mean(dim=1).squeeze()

    def get_sentiment_score(self, text):
        if not text.strip():
            return torch.tensor([0.5, 0.0])
        result = sentiment_analyzer(text[:512])[0]
        label_id = 1.0 if result["label"] == "POSITIVE" else 0.0
        return torch.tensor([label_id, result["score"]], dtype=torch.float)

    def get_liwc_style_counts(self, text):
        tokens = text.lower().split()
        if not tokens:
            return torch.zeros(3)
        return torch.tensor([
            sum(1 for t in tokens if t in NEGATIONS) / len(tokens),
            sum(1 for t in tokens if t in COGNITIVE) / len(tokens),
            sum(1 for t in tokens if t in AFFECTIVE) / len(tokens)
        ], dtype=torch.float)

    def get_syntactic_complexity(self, text):
        if not text.strip():
            return torch.zeros(3)
        doc = nlp(text)
        sents = list(doc.sents)
        avg_sent_len = sum(len(s) for s in sents) / len(sents) if sents else 0
        total = len(doc)
        noun_ratio = sum(1 for t in doc if t.pos_ == "NOUN") / total if total else 0
        verb_ratio = sum(1 for t in doc if t.pos_ == "VERB") / total if total else 0
        return torch.tensor([avg_sent_len, noun_ratio, verb_ratio], dtype=torch.float)

    def get_disfluency_features(self, text):
        tokens = text.lower().split()
        if not tokens:
            return torch.zeros(2)
        filler_frac = sum(1 for t in tokens if t in FILLERS) / len(tokens)
        repeated_frac = sum(1 for i in range(1, len(tokens)) if tokens[i] == tokens[i - 1]) / len(tokens)
        return torch.tensor([filler_frac, repeated_frac], dtype=torch.float)

    def extract_features_from_text(self, text):
        emb = self.get_contextual_embedding(text)
        sent = self.get_sentiment_score(text)
        liwc = self.get_liwc_style_counts(text)
        synt = self.get_syntactic_complexity(text)
        disf = self.get_disfluency_features(text)
        return torch.cat([emb, sent, liwc, synt, disf], dim=0)

    def extract(self, input_wmv: str, save_path: str = "text_features.pkl"):
        output_wav = "temp_audio.wav"
        self.features = []

        if os.path.exists(save_path):
            print(f"[INFO] Found existing features at {save_path}, loading...")
            self.load_from_file(save_path)
            return

        self.extract_audio_from_wmv(input_wmv, output_wav)
        segments = self.transcribe(output_wav)

        if not segments:
            print("[WARN] No segments found in transcription.")
            return []

        total_duration = segments[-1]["end"]
        chunked = self.chunk_text_by_time(segments, total_duration)

        for _, _, text in chunked:
            print(text)
            features = self.extract_features_from_text(text)
            self.features.append(features)

        print(f"[INFO] Extracted {len(self.features)} feature vectors (one per second).")
        self.save_to_file(save_path)

    def extract_without_save(self, input_wmv: str):
        output_wav = "temp_audio.wav"
        self.features = []
        self.extract_audio_from_wmv(input_wmv, output_wav)
        segments = self.transcribe(output_wav)

        if not segments:
            print("[WARN] No segments found in transcription.")
            return []

        total_duration = segments[-1]["end"]
        chunked = self.chunk_text_by_time(segments, total_duration)

        for _, _, text in chunked:
            print("Text:",text)
            features = self.extract_features_from_text(text)
            self.features.append(features)

        print(f"[INFO] Extracted {len(self.features)} feature vectors (one per second).")


    def extract_features_from_audio_window(self, audio_window: np.ndarray, sample_rate: int = 22050):
        """
        Save the 1s audio window as a temp .wav and extract features using whisper + feature stack.
        """
        # Save temporary wav file
        temp_path = f"temporary_window{time.time()}.wav"
        sf.write(temp_path, audio_window, sample_rate)

        # Load whisper model once if not already done
        if not hasattr(self, "whisper_loaded"):
            self.whisper_loaded = whisper.load_model(self.whisper_model)

        # Transcribe (keep it short to avoid latency)
        result = self.whisper_loaded.transcribe(temp_path, task="transcribe", language="en")
        text = result["text"].strip()
        print("Text:", text)

        return self.extract_features_from_text(text), text  # shape: (778,)

    def save_to_file(self, save_path: str):
        with open(save_path, 'wb') as f:
            pickle.dump(self.features, f)
        print(f"[INFO] Text features saved to {save_path}")

    def load_from_file(self, save_path: str):
        with open(save_path, 'rb') as f:
            self.features = pickle.load(f)
        print(f"[INFO] Text features loaded from {save_path}")

    def get_results(self):
        return self.features
