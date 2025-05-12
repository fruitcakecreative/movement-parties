import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_BASE;

const api = axios.create({
  baseURL: API_BASE_URL,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});


export const fetchEvents = async () => {
  const response = await api.get('/events');
  return response.data;
};

//login/logout
export const userLogin = async (credentials) => {
  const response = await api.post("/login", { user: credentials });
  return response.data;
};

export const userLogout = async () => {
  await api.delete("/logout");
  localStorage.removeItem("user");
  window.location.href = "/login";
};

//attending/interested event buttons
export const fetchUserEvents = async () => {
  const response = await api.get('/user_events');
  return response.data;
}

export const saveUserEventStatus = async (eventId, status) => {
  return api.post("/user_events", {
    user_event: {
      event_id: Number(eventId), // ensure it’s a number
      status
    }
  });
};

export const deleteUserEventStatus = async (eventId, status) => {
  return api.delete("/user_events", {
    data: { user_event: { event_id: eventId, status } },
  });
};

//user profile info
export const fetchUserInfo = async (token) => {
  const response = await api.get("/user");
  return response.data;
};

export default api;
