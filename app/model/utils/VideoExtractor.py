import mediapipe as mp
import cv2 as cv
import numpy as np
import pickle
import os

class VideoExtractor:
    def __init__(self, model_path: str):
        self.model_path = model_path
        self.fps = None
        self.landmark_windows = []

        self.BaseOptions = mp.tasks.BaseOptions
        self.FaceLandmarker = mp.tasks.vision.FaceLandmarker
        self.FaceLandmarkerOptions = mp.tasks.vision.FaceLandmarkerOptions
        self.VisionRunningMode = mp.tasks.vision.RunningMode

    def extract(self, video_path: str, save_path: str = "landmarks_avg.pkl"):
        if os.path.exists(save_path):
            print(f"[INFO] Found existing features at {save_path}, loading...")
            self.load_from_file(save_path)
            return

        cap = cv.VideoCapture(video_path)
        if not cap.isOpened():
            raise ValueError(f"Unable to open video file {video_path}")

        self.fps = int(cap.get(cv.CAP_PROP_FPS))
        print(f"[INFO] Detected FPS: {self.fps}")

        options = self.FaceLandmarkerOptions(
            base_options=self.BaseOptions(model_asset_path=self.model_path),
            running_mode=self.VisionRunningMode.VIDEO
        )

        self.landmark_windows = []
        with self.FaceLandmarker.create_from_options(options) as landmarker:
            frame_idx = 1
            current_window = []
            window_index = 1

            while cap.isOpened():
                ret, frame = cap.read()
                if not ret:
                    break

                mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=np.array(frame))
                result = landmarker.detect_for_video(mp_image, frame_idx)

                if result.face_landmarks:
                    face = result.face_landmarks[0]
                    face_data = [(lm.x, lm.y, lm.z) for lm in face]
                    current_window.append(face_data)

                if frame_idx % self.fps == 0 and current_window:
                    window_np = np.array(current_window)  # shape: (N_frames, 468, 3)
                    avg_landmarks = np.mean(window_np, axis=0)
                    self.landmark_windows.append({
                        "window": window_index,
                        "avg_landmarks": avg_landmarks.tolist()
                    })
                    print(f"[INFO] Window {window_index} processed with {len(current_window)} frames.")
                    window_index += 1
                    current_window = []

                frame_idx += 1

            cap.release()
            cv.destroyAllWindows()

        self.save_to_file(save_path)

    def extract_without_save(self, video_path: str):

        cap = cv.VideoCapture(video_path)
        if not cap.isOpened():
            raise ValueError(f"Unable to open video file {video_path}")

        self.fps = int(cap.get(cv.CAP_PROP_FPS))
        print(f"[INFO] Detected FPS: {self.fps}")

        options = self.FaceLandmarkerOptions(
            base_options=self.BaseOptions(model_asset_path=self.model_path),
            running_mode=self.VisionRunningMode.VIDEO
        )

        self.landmark_windows = []
        with self.FaceLandmarker.create_from_options(options) as landmarker:
            frame_idx = 1
            current_window = []
            window_index = 1

            while cap.isOpened():
                ret, frame = cap.read()
                if not ret:
                    break

                mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=np.array(frame))
                result = landmarker.detect_for_video(mp_image, frame_idx)

                if result.face_landmarks:
                    face = result.face_landmarks[0]
                    face_data = [(lm.x, lm.y, lm.z) for lm in face]
                    current_window.append(face_data)

                frame_idx += 1

                # Normal processing
                if current_window:
                    window_np = np.array(current_window)  # shape: (N_frames, 468, 3)
                    avg_landmarks = np.mean(window_np, axis=0)
                    print("Average landmarks: ", avg_landmarks)
                else:
                    # Fallback: use all-zero array
                    avg_landmarks = np.zeros((1434, 1))
                    print("[WARNING] No face detected. Returning zero landmarks.")

                self.landmark_windows.append({
                    "window": window_index,
                    "avg_landmarks": avg_landmarks.tolist()
                })
                print(f"[INFO] Window {window_index} processed with {len(current_window)} frames.")

            cap.release()
            cv.destroyAllWindows()


    def get_landmarks_from_frame(self, frame: np.ndarray) -> np.ndarray:
        if frame is None:
            return None

        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=cv.cvtColor(frame, cv.COLOR_BGR2RGB))
        options = self.FaceLandmarkerOptions(
            base_options=self.BaseOptions(model_asset_path=self.model_path),
            output_face_blendshapes=True,
            output_facial_transformation_matrixes=True,
            num_faces=1
        )

        self.landmark_windows = []
        with self.FaceLandmarker.create_from_options(options) as landmarker:
            result = landmarker.detect(mp_image)

            if result.face_landmarks:
                landmarks = result.face_landmarks[0]
                flat = np.array([[lm.x, lm.y, lm.z] for lm in landmarks]).flatten()
                return flat  # shape: (1404,)
            return None

    def save_to_file(self, save_path: str):
        with open(save_path, 'wb') as f:
            pickle.dump(self.landmark_windows, f)
        print(f"[INFO] Saved landmark data to {save_path}")

    def load_from_file(self, save_path: str):
        if not os.path.exists(save_path):
            raise FileNotFoundError(f"No saved file found at {save_path}")
        with open(save_path, 'rb') as f:
            self.landmark_windows = pickle.load(f)
        print(f"[INFO] Loaded landmark data from {save_path}")

    def get_results(self):
        return self.landmark_windows
