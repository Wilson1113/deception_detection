# DecepTrack - Real-Time Deception Detection System

DecepTrack is an deception detection system developed as a Final Year Project at Monash University Malaysia. It leverages emotional cues through multimodal analysis of video, audio, and text data to provide real-time feedback on the truthfulness of statements.

## Overview

DecepTrack combines computer vision, audio processing, and natural language processing to:
- Analyze facial micro-expressions and emotional states
- Detect vocal stress patterns and anomalies
- Process linguistic patterns and verbal indicators of deception
- Provide real-time confidence scores for deception detection

## Key Features

- **Real-time Analysis**: 
  - Live video and audio stream processing
  - Instant feedback on deception indicators
  - Frame-by-frame facial analysis
  - Continuous voice pattern monitoring

- **Multimodal Processing**: 
  - Video: Facial expression analysis, landmark detection, and emotion classification
  - Audio: Voice pattern analysis, stress detection, and tonal variations
  - Text: Natural language processing of speech transcripts for deceptive patterns

- **User Interface**:
  - Clean, intuitive dashboard design
  - Real-time visualization of detection metrics
  - Historical analysis review
  - Detailed session reports and statistics

- **Security & Privacy**:
  - Secure user authentication
  - Encrypted data storage
  - Configurable privacy settings
  - GDPR-compliant data handling

## Technology Stack

### Frontend
- React.js
- Tailwind CSS for styling
- Real-time video/audio capture and streaming
- Supabase Client SDK

### Backend
- Flask API server
- PyTorch for machine learning models
- OpenCV for video processing
- Librosa for audio processing
- Supabase for data management
- JWT for authentication

### Machine Learning
- Custom CNN for facial analysis
- LSTM networks for temporal pattern recognition
- Transformer models for text analysis
- Ensemble methods for final decision making

## Prerequisites

- Python 3.8+
- Node.js 16+
- npm 8+ or yarn 1.22+
- CUDA-capable GPU (recommended)
- Webcam and microphone
- Web browser

## Installation

### Backend Setup

1. Clone the repository and navigate to the backend:
```bash
git clone [repository-url]
cd app
```

2. Create and activate virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Configure environment:
```bash
cp .env.example .env
# Edit .env with your credentials
```

### Frontend Setup

1. Navigate to the React application:
```bash
cd Web\ \(React\)
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment:
```bash
cp .env.example .env
# Configure your environment variables
```

## Running the Application

1. Start the backend server:
```bash
cd app
python app.py
```

2. Start the frontend development server:
```bash
cd Web\ \(React\)
npm start
```

3. Access the application at `http://localhost:3000`

## Usage Guide

1. **Initial Setup**
   - Create an account or login
   - Complete profile setup
   - Grant necessary permissions

2. **Starting an Analysis**
   - Navigate to Analysis page
   - Enter subject details
   - Configure analysis parameters
   - Begin recording session

3. **During Analysis**
   - Monitor real-time metrics
   - Observe confidence scores
   - Review emotional indicators

4. **Post-Analysis**
   - Access detailed reports
   - Export session data
   - Review historical trends

## Usage

1. Create an account or log in to your existing account
2. Navigate to the Analysis page
3. Grant camera and microphone permissions when prompted
4. Enter the subject's name and identification number
5. Click "Start Analysis" to begin the deception detection process
6. View real-time results including:
   - Detected emotions
   - Deception confidence scores
   - Timestamps of analysis


## Acknowledgments

- This project was developed as part of a Final Year Project at Monash University Malaysia by Group MCS21.

© 2025 DecepTrack - MCS21 Monash University Malaysia
