import React, { useEffect, useState } from "react";
import supabase from "../../helper/supabaseClient";
import { useNavigate } from "react-router-dom";

function ProfilePanel({ session }) {
  const navigate = useNavigate();
  const [profile, setProfile] = useState(null);
  const [newName, setNewName] = useState("");
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState("");

  const [nameError, setNameError] = useState("");

  useEffect(() => {
    if (session && session.user && session.user.user_metadata?.full_name) {
      setNewName(session.user.user_metadata.full_name);
    }
  }, [session]);

  const handleSave = async () => {
    setNameError('');
    setMessage('');

    if (!newName.trim()) {
      setNameError('Full name is required.');
      return;
    }

    setSaving(true);

    const { user } = session;
    const { data, error } = await supabase.auth.updateUser({
      data: { full_name: newName }
    });

    if (error) {
      setMessage('Failed to update name.');
      console.error(error.message);
    }

    if (data) {
      setMessage("Profile updated successfully.");
      setProfile({ ...profile, full_name: newName });
    }

    setSaving(false);
  };

  if (!session || !session.user) {
    return <div className="text-center mt-10 text-gray-600">Loading session...</div>;
  }

  return (
    <div className="bg-white rounded-xl shadow-md p-4 m-4 space-y-6 ">
      <h2 className="text-xl font-semibold text-blue-700">Your Profile</h2>

      {message && <p className="text-sm text-green-600">{message}</p>}

      {/* Row layout for name + email */}
      <div className="flex flex-col md:flex-row md:items-center md:gap-6">
        {/* Full Name Field */}
        <div className="flex-1">
          <label className="block text-sm font-medium text-gray-600 mb-1">Full Name</label>
          <input
            onChange={(e) => setNewName(e.target.value)}
            value={newName}
            type="text"
            className={`w-full border ${nameError ? 'border-red-500' : 'border-gray-300'} px-4 py-2 rounded-md focus:outline-none focus:ring-2 ${nameError ? 'focus:ring-red-500' : 'focus:ring-blue-500'}`}
            placeholder="Full Name"
          />
          {nameError && <p className="text-sm text-red-600 mt-1">{nameError}</p>}
        </div>

        {/* Email Field (read-only) */}
        <div className="flex-1 mt-4 md:mt-0">
          <label className="block text-sm font-medium text-gray-600 mb-1">Email</label>
          <input
            type="email"
            value={session.user.email}
            readOnly
            className="w-full border border-gray-300 px-4 py-2 text-gray-400 rounded-md bg-gray-50"
          />
        </div>
      </div>

      {/* Save Button */}
      <div className="flex justify-end">
        <button
          onClick={handleSave}
          disabled={saving}
          className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition"
        >
          {saving ? "Saving..." : "Save Changes"}
        </button>
      </div>
    </div>
  );
}

export default ProfilePanel;
