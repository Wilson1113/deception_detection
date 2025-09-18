import React, { useRef, useState, useEffect } from 'react';
import supabase from "../helper/supabaseClient";
import { NavLink, useNavigate } from 'react-router-dom';
import Layout from './Layout';
const DecepTrack = () => {

  const navigate = useNavigate();
  const videoRef = useRef(null);
  const [stream, setStream] = useState(null);
  const [cameraOn, setCameraOn] = useState(false);
  const [micOn, setMicOn] = useState(false);
  const [mediaRecorder, setMediaRecorder] = useState(null);
  const [chunks, setChunks] = useState([]);
  const [sessionId, setSessionId] = useState(null);
  const [userId, setUserId] = useState(null);
  const [name, setName] = useState("");
  const [idNo, setIdNo] = useState("");
  const [isRecording, setIsRecording] = useState(false);
  const [status, setStatus] = useState("Waiting for input…");
  const [detectedEmotion, setDetectedEmotion] = useState("");
  const [deceptionConfidence, setDeceptionConfidence] = useState("");
  const [resultTimestamp, setResultTimestamp] = useState("—");
  const headerChunkRef = useRef(null);
  const chunkPromisesRef = useRef([]);
  const [isFinalizing, setIsFinalizing] = useState(false);
  const [finalResultRendered, setFinalResultRendered] = useState(false);

  const latestResultRef = useRef({
    label: "",
    prob: null,
  });  

  // fetch user ID once
  useEffect(() => {
    const fetchUser = async () => {
      const session = await supabase.auth.getSession();
      setUserId(session.data?.session?.user?.id || null);
    };
    fetchUser();
  }, []);
  
  const toggleCamera = async () => {
    if (!cameraOn) {
      try {
        const newStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
        if (videoRef.current) {
          videoRef.current.srcObject = newStream;
        }
        setStream(newStream);
        setCameraOn(true);

        // Apply mic state
        const audioTrack = newStream.getAudioTracks()[0];
        if (audioTrack) audioTrack.enabled = micOn;
      } catch (err) {
        alert("Error accessing camera/mic: " + err.message);
      }
    } else {
      stream?.getTracks().forEach(track => track.stop());
      if (videoRef.current) videoRef.current.srcObject = null;
      setCameraOn(false);
      setMicOn(false);
    }
  };

  const toggleMic = () => {
    if (!stream) {
      alert("Camera must be turned on first.");
      return;
    }
    const newMicOn = !micOn;
    const audioTrack = stream.getAudioTracks()[0];
    if (audioTrack) audioTrack.enabled = newMicOn;
    setMicOn(newMicOn);
  };

  const signOut = async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    navigate("/login")
  };

  const startRecording = async () => {
    if (!cameraOn || !micOn) {
      let message = [];
      if (!cameraOn) message.push("camera");
      if (!micOn) message.push("microphone");
      alert(`Please turn on your ${message.join(" and ")} before starting analysis.`);
      return;
    }
    if (!stream) return alert("Camera must be turned on before proceeding.");
    if (!name || !idNo || !userId) return alert("Please enter all required information.");

    setFinalResultRendered(false);
  
    const formData = new FormData();
    formData.append("name", name);
    formData.append("id_no", idNo);
    formData.append("user_id", userId);
  
    const res = await fetch("http://127.0.0.1:5050/sessions", {
      method: "POST",
      body: formData
    });
  
    const json = await res.json();
    setSessionId(json.session_id);
  
    const recorder = new MediaRecorder(stream, { mimeType: 'video/webm' });
    setMediaRecorder(recorder);
  
    recorder.ondataavailable = e => {
      if (e.data.size === 0) return;
  
      if (!headerChunkRef.current) {
        headerChunkRef.current = e.data;
      }
      const combined = new Blob([headerChunkRef.current, e.data], {
          type: 'video/webm'
        });
      const promise = sendChunkToBackend(combined, json.session_id);
      chunkPromisesRef.current.push(promise);
    };
  
    recorder.start(1000);
    setIsRecording(true);
  };

  // For every chunk
  const sendChunkToBackend = async (blob, currentSessionId) => {
    const formData = new FormData();
    formData.append("media", blob, "chunk.webm");
    formData.append("user_id", userId);
  
    try {
      const response = await fetch(`http://127.0.0.1:5050/sessions/${currentSessionId}/chunk`, {
        method: "POST",
        body: formData,
      });
  
      const result = await response.json();
      console.log("Backend response:", result);
  
      setStatus("Result received");
      setDetectedEmotion(result.label);
      setDeceptionConfidence(
        result.prob != null
          ? result.prob < 0.5
            ? `${(result.prob * 100 * 2).toFixed(1)}%`
            : `${((result.prob - 0.5) * 100 * 2).toFixed(1)}%`
          : "—"
      );
      setResultTimestamp(new Date().toLocaleTimeString());

      latestResultRef.current = {
        label: result.label,
        prob : result.prob,
      };
    } catch (error) {
      console.error("Error sending chunk:", error);
      setStatus("Error sending chunk");
    }
  };   

  const stopRecording = async () => {
    if (!mediaRecorder) return;
  
    return new Promise((resolve) => {
      mediaRecorder.onstop = async () => {
        console.log("[INFO] Recorder stopped, waiting for all chunks...");
  
        // Wait for all sendChunkToBackend calls to finish
        await Promise.all(chunkPromisesRef.current);
        chunkPromisesRef.current = [];
  
        const { label, prob } = latestResultRef.current;
        const finalLabel = label.includes("TRUTH");  
        const finalProb  = prob;
  
        const formData = new FormData();
        formData.append("final_label", finalLabel);
        formData.append("final_prob", finalProb);
  
        await fetch(`http://127.0.0.1:5050/sessions/${sessionId}/end`, {
          method: "POST",
          body: formData,
        });
  
        console.log("Session ended.");
        setSessionId(null);
        setFinalResultRendered(true);
        resolve();
      };
  
      mediaRecorder.stop();
      setIsRecording(false);
    });
  };

  return (
    <Layout>
      <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-6 items-start pb-5">
        {/* Camera + Controls */}
        <div className="md:col-span-2 bg-black shadow-xl rounded-2xl p-6 relative">
          <div className="relative rounded-xl overflow-hidden">
            <video ref={videoRef} className="w-full h-[480px] bg-gray-500 rounded-xl shadow-md" autoPlay muted />
            {!cameraOn && (
              <div id="overlay" className="absolute top-0 left-0 w-full h-full flex items-center justify-center bg-black bg-opacity-60 text-white text-lg font-bold rounded-xl">
                Camera is off
              </div>
            )}
          </div>

          {/* Buttons */}
          <div className="flex gap-6 mt-6 justify-center">
            <button
              onClick={toggleCamera}
              className={`${cameraOn ? "bg-green-600 hover:bg-green-700" : "bg-red-600 hover:bg-red-700"} text-white p-4 rounded-full transition`}
            >
              <i className={`fas ${cameraOn ? "fa-video" : "fa-video-slash"}`}></i>
            </button>

            <button
              onClick={toggleMic}
              className={`${micOn ? "bg-green-600 hover:bg-green-700" : "bg-red-600 hover:bg-red-700"} text-white p-4 rounded-full transition`}
            >
              <i className={`fas ${micOn ? "fa-microphone" : "fa-microphone-slash"}`}></i>
            </button>
          </div>
        </div>

        {/* Analysis Results */}
        <div className="flex flex-col gap-4">
          <div className="bg-white shadow-xl rounded-2xl p-6 w-full">
            <h2 className="text-xl font-semibold text-gray-800 mb-4">Analysis Results</h2>
            <div id="results" className="space-y-4 text-sm text-gray-700">
              <p><strong>Status:</strong> {status}</p>
              <p><strong>Detected Emotion:</strong> {detectedEmotion}</p>
              <p><strong>Deception Confidence:</strong> {deceptionConfidence}</p>
              <p><strong>Timestamp:</strong> {resultTimestamp}</p>
            </div>
          </div>
          <div className="bg-white shadow-xl rounded-2xl p-6 w-full">
            <form className="space-y-4">
              <div className='relative'>
              <input
                id="name"
                name="name"
                type="text"
                placeholder='Name'
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
                className='peer h-10 w-full border text-gray-900 px-4 placeholder-transparent rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500'
              />
                <label
                  htmlFor="email"
                  className="absolute left-3 -top-2.5 text-sm text-gray-500 bg-white px-1 transition-all peer-placeholder-shown:top-2.5 peer-placeholder-shown:text-base peer-placeholder-shown:text-gray-400 peer-focus:-top-2.5 peer-focus:text-sm peer-focus:text-blue-600"
                >Name*</label>
              </div>
              <div className='relative'>
              <input
                id="idNo"
                name="idNo"
                type="text"
                placeholder='Identification No.'
                required
                value={idNo}
                onChange={(e) => setIdNo(e.target.value)}
                className='peer h-10 w-full border text-gray-900 px-4 placeholder-transparent rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500'
              />
                <label
                  htmlFor="idNo"
                  className="absolute left-3 -top-2.5 text-sm text-gray-500 bg-white px-1 transition-all peer-placeholder-shown:top-2.5 peer-placeholder-shown:text-base peer-placeholder-shown:text-gray-400 peer-focus:-top-2.5 peer-focus:text-sm peer-focus:text-blue-600"
                >Identification No.*</label>
              </div>
              <button
                type="button"
                onClick={startRecording}
                disabled={!cameraOn || !micOn || isRecording || isFinalizing || (sessionId !== null && !finalResultRendered)}
                className={`w-full text-white px-4 py-2 rounded-lg shadow-md ${
                  !cameraOn || !micOn || isRecording || isFinalizing || (sessionId !== null && !finalResultRendered)
                    ? "bg-gray-400 cursor-not-allowed"
                    : "bg-blue-600 hover:bg-blue-700"
                }`}
              >
                {isRecording ? "Recording..." : "Start Analysis"}
                {(!cameraOn || !micOn) && (
                  <div className="absolute -top-12 left-1/2 transform -translate-x-1/2 bg-gray-800 text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">
                    {!cameraOn && !micOn 
                      ? "Please enable camera and microphone"
                      : !cameraOn 
                      ? "Please enable camera"
                      : "Please enable microphone"}
                  </div>
                )}
              </button>
              <button
                type="button"
                onClick={stopRecording}
                disabled={!isRecording || isFinalizing || finalResultRendered}
                className={`${
                  !isRecording || isFinalizing
                    ? "bg-gray-400 cursor-not-allowed"
                    : "bg-red-600 hover:bg-red-700"
                } mt-2 text-white px-4 py-2 rounded-lg w-full shadow-md`}
              >
                Stop Analysis
              </button>
            </form>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default DecepTrack;