import React, { useState } from 'react';
import supabase from "../../helper/supabaseClient";
import { Link, useNavigate } from 'react-router-dom';

function Login({ setSession }) {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (event) => {
    event.preventDefault();
    setMessage("");

    const { data, error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password,
    });

    if (error) {
      setMessage(error.message);
      return;
    }

    // if (data) {
    //   navigate("/dashboard");
    // }

    if (data?.session) {
      setSession(data.session); // update session in state/context
      navigate("/profile");
    }

    setEmail("");
    setPassword("");
  };

  return (
    <div className="bg-gradient-to-br from-gray-100 to-blue-100 min-h-screen flex items-center justify-center font-sans">
      <div className="w-full max-w-md bg-white shadow-2xl rounded-2xl p-8 space-y-6">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-blue-700">DecepTrack</h1>
          <p className="text-sm text-gray-500">Leveraging Emotional Cues for Deception Detection</p>
        </div>

        {/* Display error message */}
        {message && (
          <div className="text-red-600 text-sm text-center">
            {message}
          </div>
        )}

        <form className="space-y-4" onSubmit={handleSubmit}>
          <div className='relative'>
            <input
              onChange={(e) => setEmail(e.target.value)}
              value={email}
              id="email"
              name="email"
              type="email"
              placeholder='Email'
              required
              className='peer h-10 w-full border text-gray-900 px-4 placeholder-transparent rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500'
            />
            <label
              htmlFor="email"
              className="absolute left-3 -top-2.5 text-sm text-gray-500 bg-white px-1 transition-all peer-placeholder-shown:top-2.5 peer-placeholder-shown:text-base peer-placeholder-shown:text-gray-400 peer-focus:-top-2.5 peer-focus:text-sm peer-focus:text-blue-600"
            >Email</label>
          </div>

          <div className='relative'>
            <input
              onChange={(e) => setPassword(e.target.value)}
              value={password}
              id="password"
              name="password"
              type="password"
              placeholder='password'
              required
              className='peer h-10 w-full border text-gray-900 px-4 placeholder-transparent rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500'
            />
            <label
              htmlFor="password"
              className="absolute left-3 -top-2.5 text-sm text-gray-500 bg-white px-1 transition-all peer-placeholder-shown:top-2.5 peer-placeholder-shown:text-base peer-placeholder-shown:text-gray-400 peer-focus:-top-2.5 peer-focus:text-sm peer-focus:text-blue-600"
            >Password</label>
          </div>

          <div className="flex justify-between text-sm text-gray-600">
            <Link to="/forgotPassword" className="hover:text-blue-500 hover:text-blue-700">Forgot Password?</Link>
          </div>

          <button
            type="submit"
            className="w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition"
          >
            Login
          </button>
        </form>

        <p className="text-center text-sm text-gray-500">
          Don't have an account?
          <Link to="/signup" className="text-blue-600 hover:underline"> Sign up</Link>
        </p>
      </div>
    </div>
  );
}

export default Login;
