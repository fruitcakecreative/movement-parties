import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import Events from './pages/events';
import Layout from './layout';

import Login from "./pages/login";
import Profile from "./pages/profile";
import UserProfile from "./pages/user-profile";
import Signup from "./pages/signup";
import ForgotPassword from "./pages/forgot-password";
import ResetPassword from "./pages/reset-password";
import PrivacyPolicy from "./pages/privacy";

function App() {
  return (
    <Router>
      <Routes>
        <Route element={<Layout />}>
          <Route path="/" element={<Events />} />
          <Route path="/login" element={<Login />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route path="/reset-password" element={<ResetPassword />} />
          <Route path="/profile" element={<Profile />} />
          <Route path="/users/:userId" element={<UserProfile />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/privacy-policy" element={<PrivacyPolicy />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
