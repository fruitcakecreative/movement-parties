import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import './styles/App.scss';
import Events from './pages/events';
import Layout from './layout';

import Login from "./pages/login"
import Profile from "./pages/profile"
import Signup from "./pages/signup"
import PrivacyPolicy from "./pages/privacy"

function App() {
  const [modalStack, setModalStack] = useState([]);

  return (
    <Router>
      <Routes>
        <Route element={<Layout />}>
          <Route
            path="/"
            element={<Events modalStack={modalStack} setModalStack={setModalStack} />}
          />
          <Route path="/login" element={<Login />} />
          <Route path="/profile" element={<Profile />} />
          <Route path="/signup" element={<Signup />} />4
          <Route path="/privacy" element={<PrivacyPolicy />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
