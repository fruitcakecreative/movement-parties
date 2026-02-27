import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_BASE;
const city = process.env.REACT_APP_CITY_KEY;

const api = axios.create({
  baseURL: API_BASE_URL,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

api.interceptors.request.use((config) => {
  config.headers = config.headers || {};
  config.headers["X-City-Key"] = city;     // server supports this
  // optional also add query param for easier debugging:
  // config.params = { ...(config.params || {}), city };
  return config;
});

export const fetchEvents = async () => {
  const response = await api.get('/events');
  return response.data;
};



//login/logout
export const userLogin = async (credentials) => {
  const response = await api.post('/login', { user: credentials });
  return response.data;
};

export const userLogout = async () => {
  await api.delete('/logout');
  localStorage.removeItem('user');
  window.location.href = '/login';
};

//attending/interested event buttons
export const fetchUserEvents = async () => {
  const response = await api.get('/user_events');
  return response.data;
};

export const saveUserEventStatus = async (eventId, status) => {
  return api.post('/user_events', {
    user_event: {
      event_id: Number(eventId), // ensure it’s a number
      status,
    },
  });
};

export const deleteUserEventStatus = async (eventId, status) => {
  return api.delete('/user_events', {
    data: { user_event: { event_id: eventId, status } },
  });
};

//user profile info
export const fetchUserInfo = async (token) => {
  const response = await api.get('/user');
  return response.data;
};


export const loginWithFacebook = async (userData) => {
  const res = await fetch(`${process.env.REACT_APP_API_BASE}/users/create_from_facebook`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    credentials: 'include',
    body: JSON.stringify({ user: userData }),
  });

  return res.json();
};


export const fetchAllUsers = async () => {
  const res = await api.get('/users');
  return res.data;
};

export const fetchFriendshipList = async () => {
  const res = await api.get('/friendships');
  return res.data;
};

export const sendFriendRequest = async (username) => {
  return api.post('/friendships', { username });
};

export const acceptFriendRequest = async (user_id) => {
  return api.post("/friendships/accept", { user_id });
};

export const cancelFriendRequest = async (username) => {
  return api.delete("/friendships", { data: { username } });
};

export const rejectFriendRequest = async (user_id) => {
  return api.post("/friendships/reject", { user_id });
};


export default api;
