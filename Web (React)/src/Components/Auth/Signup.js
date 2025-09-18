import React, {useState} from 'react';
import { Link, useNavigate } from 'react-router-dom';
import supabase from "../../helper/supabaseClient";

function SignUp() {

  const navigate = useNavigate();
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (event) => {
    event.preventDefault();
    setMessage("");

    if (password !== confirmPassword){
      setMessage("Passwords do not match.");
    }

    const {data, error} = await supabase.auth.signUp({
      email: email,
      password: password,
      options:{
        data: {
          full_name: fullName,
        }
      }
    });

    if (error){
      setMessage(error.message);
      return;
    }

    if (data?.user) {
      const { error: userError } = await supabase
        .from("user")
        .insert([
          {
            id: data.user.id,
            name: fullName,
            improve_model: true
          }
        ]);
    
      if (userError) {
        console.error("Error inserting profile:", userError.message);
        setMessage("Signup succeeded but profile setup failed.");
      } else {
        navigate("/dashboard");
      }
    }

    setEmail("")
    setPassword("");;
    setConfirmPassword("");
    setFullName("");
  };

  return(
    <div className="bg-gradient-to-br from-gray-100 to-blue-100 min-h-screen flex items-center justify-center font-sans">
      <div className="w-full max-w-md bg-white shadow-2xl rounded-2xl p-8 space-y-6">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-blue-700">Create an Account</h1>
          <p className="text-sm text-gray-500">Join DecepTrack – Leveraging Emotional Cues for Deception Detection</p>
        </div>

        {/* Display error message */}
        {message && (
          <div className="text-red-600 text-sm text-center">
            {message}
          </div>
        )}

        <form className="space-y-4" onSubmit={handleSubmit}>
          <div>
            <label htmlFor="name" className="block text-sm font-medium text-gray-700">Full Name</label>
            <input
              onChange={(e) => setFullName(e.target.value)}
              value={fullName}
              id="name"
              name="name"
              type="text"
              placeholder='Name'
              required
              className="mt-1 w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label htmlFor="email" className="block text-sm font-medium text-gray-700">Email</label>
            <input
              onChange={(e) => setEmail(e.target.value)}
              value={email}
              id="email"
              name="email"
              type="email"
              placeholder='Email'
              required
              className="mt-1 w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label htmlFor="password" className="block text-sm font-medium text-gray-700">Password</label>
            <input
              onChange={(e) => setPassword(e.target.value)}
              value={password}
              id="password"
              name="password"
              type="password"
              placeholder='Password'
              required
              className="mt-1 w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label htmlFor="confirm-password" className="block text-sm font-medium text-gray-700">Confirm Password</label>
            <input
              onChange={(e) => setConfirmPassword(e.target.value)}
              value={confirmPassword}
              id="confirm-password"
              name="confirm-password"
              type="password"
              placeholder='Confirm Password'
              required
              className="mt-1 w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <button
            type="submit"
            className="w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition"
          >
            Sign Up
          </button>
        </form>

        <p className="text-center text-sm text-gray-500">
          Already have an account?
          <Link to="/login" className="text-blue-600 hover:underline"> Login</Link>
        </p>
      </div>
    </div>  
  )
}

export default SignUp;
