import os
import pickle
import numpy as np
from model.utils.AudioExtractor import AudioExtractor
from model.utils.VideoExtractor import VideoExtractor
from model.utils.TextExtractor import TextExtractor
from sklearn.preprocessing import StandardScaler
import logging
import torch

class FusionExtractor:
    def __init__(self, model_path: str = "../face_landmarker.task", window_size: float = 1.0, log_path: str = "fusion.log"):
        self.model_path = model_path
        self.window_size = window_size
        self.fused_data = []

        self.log_path = log_path

        logging.basicConfig(
            filename=self.log_path,
            level=logging.INFO,
            format="%(asctime)s [%(levelname)s] %(message)s",
            filemode='w'  # overwrite log file each run
        )
        self.logger = logging.getLogger("FusionExtractor")

    def extract(self, video_path: str, save_path: str = "fused_features.pkl"):
        fused_path = "../../fused/" + save_path + "_fused.pkl"
        if os.path.exists(fused_path):
            print(f"[INFO] Found existing fused data at {save_path}, loading...")
            self.load_from_file(fused_path)
            return

        # Extract Video
        print("[INFO] Extracting video landmarks...")
        video_extractor = VideoExtractor(self.model_path)
        video_extractor.extract(
            video_path=video_path,
            save_path="../../video/" + save_path + "_video.pkl"
        )
        video_landmarks = video_extractor.get_results()
        video_vectors = np.array([
            np.array(frame['avg_landmarks']).flatten()
            for frame in video_landmarks
        ])
        scaler_video = StandardScaler()
        video = scaler_video.fit_transform(video_vectors)

        # --- NEW raw‐feature audio path ---
        print("[INFO] Extracting audio features...")
        audio_extractor = AudioExtractor()
        audio_extractor.extract(
            audio_path=video_path,
            save_path="../../audio/" + save_path + "_audio.pkl"
        )
        af = audio_extractor.get_results()
        mel = af['mel']
        mfcc = af['mfcc']
        chroma = af['chroma']

        # concatenate mel, mfcc, chroma per window
        audio_vectors = [
            np.concatenate([mel[i], mfcc[i], chroma[i]])
            for i in range(len(mel))
        ]
        # standard‐scale across windows
        scaler_audio = StandardScaler()
        audio = scaler_audio.fit_transform(audio_vectors)

        # Extract Text
        print("[INFO] Extracting text features...")
        text_extractor = TextExtractor(window_size=self.window_size)
        text_extractor.extract(
            input_wmv=video_path,
            save_path="../../text/" + save_path + "_text.pkl"
        )
        text_vectors = text_extractor.get_results()
        scaler_text = StandardScaler()
        text = scaler_text.fit_transform(text_vectors)

        # Fuse
        print("\n[INFO] Fusing all features...")
        num_windows = min(len(video_landmarks), len(audio_vectors), len(text_vectors))
        label = self.get_label_from_filename(video_path)

        self.fused_data = []
        for i in range(num_windows):
            self.fused_data.append({
                "window": i + 1,
                "video": video[i].tolist(),
                "audio": audio[i].tolist(),
                "text": text[i].tolist(),
                "label": label
            })

        print(f"[INFO] Total fused windows: {len(self.fused_data)}")
        self.save_to_file(fused_path)

    def extract_without_save(self, video_path: str):
        # Extract Video
        print("[INFO] Extracting video landmarks...")
        video_extractor = VideoExtractor(self.model_path)
        video_extractor.extract_without_save(
            video_path=video_path
        )
        video_landmarks = video_extractor.get_results()
        # print("Video landmarks:",  video_landmarks)
        video_vectors = np.array([
            np.array(frame['avg_landmarks']).flatten()
            for frame in video_landmarks
        ])

        # --- NEW raw‐feature audio path ---
        print("[INFO] Extracting audio features...")
        audio_extractor = AudioExtractor()
        audio_extractor.extract_without_save(
            audio_path=video_path
        )
        af = audio_extractor.get_results()
        mel = af['mel']
        mfcc = af['mfcc']
        chroma = af['chroma']

        # concatenate mel, mfcc, chroma per window
        audio_vectors = [
            np.concatenate([mel[i], mfcc[i], chroma[i]])
            for i in range(len(mel))
        ]

        # Extract Text
        print("[INFO] Extracting text features...")
        text_extractor = TextExtractor(window_size=self.window_size)
        text_extractor.extract_without_save(
            input_wmv=video_path
        )
        text_vectors = text_extractor.get_results()
        if not text_vectors:
            # Suppose your model expects, say, 778 text features:
            text_vectors = np.zeros((1, 778))


        # Fuse
        # print("\n[INFO] Fusing all features...")
        # print("video", video_path)
        # print("audio", audio_vectors)
        # print("text", text_vectors)
        num_windows = min(len(video_vectors), len(audio_vectors), len(text_vectors))
        label = self.get_label_from_filename(video_path)

        self.fused_data = []
        for i in range(num_windows):
            self.fused_data.append({
                "window": i + 1,
                "video": video_vectors[i].tolist(),
                "audio": audio_vectors[i].tolist(),
                "text": text_vectors[i].tolist(),
                "label": label
            })

        print(f"[INFO] Total fused windows: {len(self.fused_data)}")

    # def get_latest_features(self):



    def save_to_file(self, save_path: str):
        with open(save_path, 'wb') as f:
            pickle.dump(self.fused_data, f)
        print(f"[INFO] Fused data saved to {save_path}")

    def load_from_file(self, save_path: str):
        with open(save_path, 'rb') as f:
            self.fused_data = pickle.load(f)
        print(f"[INFO] Loaded fused data from {save_path}")

    def get_results(self):
        return self.fused_data

    def normalize(self, x):
        return (x - x.min()) / (x.max() - x.min())

    def log(self, sample: int = 3):
        self.logger.info(f"Logging first {sample} fused data entries...")

        for i, item in enumerate(self.fused_data[:sample]):
            self.logger.info(f"Video vector length: {len(item['video'])}")
            self.logger.info(f"Audio vector length: {len(item['audio'])}")
            self.logger.info(f"Text vector length: {len(item['text'])}")
            self.logger.info(item)
            break

    def fuse_realtime(self, video_vec: np.ndarray, audio_vec: np.ndarray, text_vec: torch.Tensor) -> np.ndarray:
        """
        Fuse a single real-time vector from video, audio, and text inputs.
        - video_vec: shape (1434,)
        - audio_vec: shape (6732,)
        - text_vec:  shape (778,) as torch.Tensor
        Returns:
            fused: shape (8944,) numpy array
        """
        if isinstance(text_vec, torch.Tensor):
            text_vec = text_vec.detach().cpu().numpy()

        # Optional: normalize (if consistent with training)
        fused = np.concatenate([video_vec, audio_vec, text_vec])
        assert fused.shape[0] == 8944, f"Fused vector has incorrect shape: {fused.shape}"
        return fused

    def get_label_from_filename(self, filename: str):
        base = os.path.splitext(os.path.basename(filename))[0]
        code = base[-2:].upper()
        human_map = {
            "PT": "positive_truth",
            "NT": "negative_truth",
            "PL": "positive_lie",
            "NL": "negative_lie",
        }

        return human_map.get(code, code)