import librosa
import numpy as np
import pickle
from sklearn.preprocessing import StandardScaler
import os

class AudioExtractor:
    def __init__(self):
        self.sample_rate = None
        self.audio = None
        self.features = {}

    def extract(self,
                audio_path: str,
                save_path: str = "audio_features.pkl",
                window_length: float = 1.0,
                hop_length:   float = 1.0):
        # load cached if present
        if os.path.exists(save_path):
            print(f"[INFO] Found existing features at {save_path}, loading...")
            self.load_from_file(save_path)
            return

        # 1) load audio
        self.audio, self.sample_rate = librosa.load(audio_path)
        print(f"[INFO] Loaded audio: {audio_path}")
        print(f"[INFO] Sample rate: {self.sample_rate}, Duration: {len(self.audio)/self.sample_rate:.2f}s")

        # 2) framing
        win_size = int(window_length * self.sample_rate)
        hop_size = int(hop_length   * self.sample_rate)
        num_windows = int(np.ceil((len(self.audio) - win_size)/hop_size)) + 1

        mel_list, mfcc_list, chroma_list = [], [], []

        for i in range(num_windows):
            start = i * hop_size
            end   = start + win_size
            if end > len(self.audio):
                break
            seg = self.audio[start:end]

            # extract per-frame features
            mel    = librosa.feature.melspectrogram(y=seg, sr=self.sample_rate, n_mels=128)
            mel_db = librosa.power_to_db(mel, ref=np.max)
            mfcc   = librosa.feature.mfcc(y=seg, sr=self.sample_rate, n_mfcc=13)
            chroma = librosa.feature.chroma_stft(y=seg, sr=self.sample_rate)

            mel_list.append(mel_db.flatten())
            mfcc_list.append(mfcc.flatten())
            chroma_list.append(chroma.flatten())

        # 3) stack into arrays
        mel_array    = np.vstack(mel_list)
        mfcc_array   = np.vstack(mfcc_list)
        chroma_array = np.vstack(chroma_list)

        # 4) normalize each
        scaler = StandardScaler()
        mel_scaled    = scaler.fit_transform(mel_array)
        mfcc_scaled   = scaler.fit_transform(mfcc_array)
        chroma_scaled = scaler.fit_transform(chroma_array)

        # 5) store directly (no PCA)
        self.features = {
            "mel": mel_scaled,
            "mfcc": mfcc_scaled,
            "chroma": chroma_scaled,
            "window_times": np.arange(len(mel_scaled)) * hop_length
        }

        self.save_to_file(save_path)

    def extract_without_save(self,
                audio_path: str,
                window_length: float = 1.0,
                hop_length: float = 1.0):
        # load cached if present

        # 1) load audio
        self.audio, self.sample_rate = librosa.load(audio_path)
        print(f"[INFO] Loaded audio: {audio_path}")
        print(f"[INFO] Sample rate: {self.sample_rate}, Duration: {len(self.audio) / self.sample_rate:.2f}s")



        # 2) framing
        win_size = int(window_length * self.sample_rate)
        hop_size = int(hop_length * self.sample_rate)
        num_windows = int(np.ceil((len(self.audio) - win_size) / hop_size)) + 1

        min_audio_length = win_size  # or even a few windows like: win_size * 2

        if len(self.audio) < min_audio_length:
            pad_length = min_audio_length - len(self.audio)
            self.audio = np.pad(self.audio, (0, pad_length), mode='constant')

        mel_list, mfcc_list, chroma_list = [], [], []

        for i in range(num_windows):
            start = i * hop_size
            end = start + win_size
            if end > len(self.audio):
                break
            seg = self.audio[start:end]

            # extract per-frame features
            mel = librosa.feature.melspectrogram(y=seg, sr=self.sample_rate, n_mels=128)
            mel_db = librosa.power_to_db(mel, ref=np.max)
            mfcc = librosa.feature.mfcc(y=seg, sr=self.sample_rate, n_mfcc=13)
            chroma = librosa.feature.chroma_stft(y=seg, sr=self.sample_rate)

            mel_list.append(mel_db.flatten())
            mfcc_list.append(mfcc.flatten())
            chroma_list.append(chroma.flatten())

        # 3) stack into arrays
        mel_array = np.vstack(mel_list)
        mfcc_array = np.vstack(mfcc_list)
        chroma_array = np.vstack(chroma_list)

        # 5) store directly (no PCA)
        self.features = {
            "mel": mel_array,
            "mfcc": mfcc_array,
            "chroma": chroma_array,
            "window_times": np.arange(len(mel_array)) * hop_length
        }


    def get_features_from_window(self, seg):
        mel = librosa.feature.melspectrogram(y=seg, sr=22050, n_mels=128)
        mel_db = librosa.power_to_db(mel, ref=np.max)
        mfcc = librosa.feature.mfcc(y=seg, sr=22050, n_mfcc=13)
        chroma = librosa.feature.chroma_stft(y=seg, sr=22050)

        scaler = StandardScaler()
        mel_scaled = scaler.fit_transform(mel_db)
        mfcc_scaled = scaler.fit_transform(mfcc)
        chroma_scaled = scaler.fit_transform(chroma)

        return np.concatenate([mel_scaled, mfcc_scaled, chroma_scaled]).ravel()


    def save_to_file(self, save_path: str):
        with open(save_path, "wb") as f:
            pickle.dump(self.features, f)
        print(f"[INFO] Audio features saved to {save_path}")

    def load_from_file(self, save_path: str):
        with open(save_path, "rb") as f:
            self.features = pickle.load(f)
        print(f"[INFO] Audio features loaded from {save_path}")

    def get_results(self):
        return self.features
