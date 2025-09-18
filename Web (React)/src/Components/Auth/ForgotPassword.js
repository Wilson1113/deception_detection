import React, { useState } from "react";
import supabase from "../../helper/supabaseClient";

function ForgotPassword(){
    const [email, setEmail] = useState("");
    const [message, setMessage] = useState("");

    const handleReset = async (e) => {
        e.preventDefault();
        setMessage("");

        const {error} = await supabase.auth.resetPasswordForEmail(email, {
            redirectTo: 'http://localhost:3000/resetPassword'
        });

        if (error) {
            setMessage(error.message);
        } else {
            setMessage("Password reset email sent. Please check your inbox.");
        }
    };

    return (
        <div className="bg-gradient-to-br from-gray-100 to-blue-100 min-h-screen flex items-center justify-center font-sans">
            <div className="min-h-screen flex items-center justify-center">
                <form onSubmit={handleReset} className="bg-white p-6 rounded-lg shadow-md w-full max-w-sm">
                    <h2 className="text-2xl font-bold mb-4 text-center">Forgot Password</h2>

                    {message && <p className="text-center text-sm text-red-600 mb-4">{message}</p>}

                    <input
                    onChange={(e) => setEmail(e.target.value)}
                    value={email}
                    type="email"
                    placeholder="Enter your email"
                    className="w-full px-4 py-2 mb-4 border border-gray-300 rounded"
                    required/>

                    <button type="submit" className="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">Send Reset Link</button>
                </form>
            </div>
        </div>
    );
}

export default ForgotPassword;