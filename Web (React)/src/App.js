import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useState, useEffect } from 'react';
import supabase from './helper/supabaseClient';

import DecepTrack from './Components/DecepTrack';
import Dashboard from './Components/Dashboard';
import Login from './Components/Auth/Login';
import SignUp from './Components/Auth/Signup';
import Wrapper from './Components/Auth/Wrapper';
import ForgotPassword from './Components/Auth/ForgotPassword';
import ResetPassword from './Components/Auth/ResetPassword';
import Settings from './Components/Setting/SettingPage';

function App() {
  const [session, setSession] = useState(null);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
    })

    supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
    })
  }, [])

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={session ? <Navigate to="/dashboard" replace /> : <Navigate to="/login" replace />} />
        <Route path="/login" element={!session ? <Login setSession={setSession} /> : <Navigate to="/dashboard" replace />} />
        <Route path="/signup" element={<SignUp />} />
        <Route path="/forgotPassword" element={<ForgotPassword />}/>
        <Route path="/resetPassword" element={<ResetPassword />}/>
        <Route path="/dashboard" element={
          <Wrapper>
            <Dashboard />
          </Wrapper>
          }/>
        <Route path="/analysis" element={
          <Wrapper>
            <DecepTrack />
          </Wrapper>
        } />
        
        <Route path="/settings" element={
          session ? (
            <Wrapper>
              <Settings session={session} />
            </Wrapper>
          ) : (
            <Navigate to="/login" replace />
          )
        } />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
