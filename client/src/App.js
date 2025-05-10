import { useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Events from './pages/events';
import Login from './pages/login';
import Signup from './pages/signup';
import Profile from './pages/profile';
import './App.scss';
import Layout from './layout';
import TicketList from "./pages/tickets";
import TicketForm from "./pages/ticket_form";

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
          <Route path="/signup" element={<Signup />} />
            <Route path="/tickets" element={<TicketList />} />
            <Route path="/tickets/new" element={<TicketForm />} />
          </Route>
      </Routes>
    </Router>
  );
}

export default App;
