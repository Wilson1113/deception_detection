import React, {useState, useEffect} from "react";
import supabase from "../../helper/supabaseClient";
import { useNavigate } from "react-router-dom";

function ResetPassword() {
    const navigate = useNavigate();
    const [newPassword, setNewPassword] = useState("");
    const [message, setMessage] = useState("");

    useEffect(() => {
        supabase.auth.getSession().then(({ data: {session}}) => {
            if (!session) {
                setMessage("You must access this page from the reset email link.");
            }
        });
    }, []);

    const handleReset = async (e) => {
        e.preventDefault();
        setMessage("");

        const {data, error} = await supabase.auth.updateUser({
            password: newPassword,
        });

        if (error){
            setMessage(error.message);
        }

        if (data){
            setMessage("Password updated! Redirecting...");
            // Force logout so user is not logged in anymore
            await supabase.auth.signOut();
            setTimeout(() => navigate("/login"), 2000);
        }
    };

    return (
        <div className="bg-gradient-to-br from-gray-100 to-blue-100 min-h-screen flex items-center justify-center font-sans">
            <div className="min-h-screen flex items-center justify-center">
                <form onSubmit={handleReset} className="bg-white p-6 rounded-lg shadow-md w-full max-w-sm">
                    <h2 className="text-2x1 font-bold mb-4 text-center">Set New Password</h2>

                    {message && <p className="text-center text-sm text-red-600 mb-4">{message}</p>}

                    <input
                    onChange={(e) => setNewPassword(e.target.value)}
                    value={newPassword}
                    type="password"
                    placeholder="New Password"
                    className="w-full px-4 py-2 mb-4 border border-gray-300 rounded"
                    required/>

                    <button type="submit" className="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700">Update Password</button>
                </form>
            </div>
        </div>
    );
}

export default ResetPassword;