import React from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import supabase from "../helper/supabaseClient";

const Layout = ({ children }) => {
  const navigate = useNavigate();

  const signOut = async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    navigate("/login");
  };

  return (
    <div className="bg-gradient-to-br from-gray-100 to-blue-100 flex flex-col min-h-screen font-sans">
      {/* Header */}
      <header className="w-full bg-white shadow-md p-4 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto flex items-center justify-between relative">
          <h1 className="text-2xl font-bold text-blue-800">DecepTrack</h1>

          <nav className="absolute left-1/2 transform -translate-x-1/2 flex gap-6">
            <NavLink to="/dashboard"
              className={({ isActive }) =>
                isActive
                  ? "text-blue-800 font-medium border-b-2 border-blue-800 pb-1"
                  : "text-blue-600 hover:text-blue-800 font-medium transition pb-1"
              }>
              Dashboard
            </NavLink>

            <NavLink to="/analysis"
              className={({ isActive }) =>
                isActive
                  ? "text-blue-800 font-medium border-b-2 border-blue-800 pb-1"
                  : "text-blue-600 hover:text-blue-800 font-medium transition pb-1"
              }>
              New Analysis
            </NavLink>

            <NavLink to="/settings"
              className={({ isActive }) =>
                isActive
                  ? "text-blue-800 font-medium border-b-2 border-blue-800 pb-1"
                  : "text-blue-600 hover:text-blue-800 font-medium transition pb-1"
              }>
              Settings
            </NavLink>
          </nav>

          <button onClick={signOut} className="text-red-600 hover:text-red-800 font-medium transition">Logout</button>
        </div>
      </header>

      {/* Main content with consistent padding */}
      <main className="flex-grow p-6 md:p-10">
        {children}
      </main>

      {/* Footer */}
      <footer className="bg-white text-center text-gray-500 text-sm py-4 shadow">
        © 2025 Leveraging Emotional Cues for Real-Time Deception Detection.
      </footer>
    </div>
  );
};

export default Layout;
