import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import './styles/App.scss';
import Events from './pages/events';
import Layout from './layout';

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
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
