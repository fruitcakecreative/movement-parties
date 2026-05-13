import axios from 'axios';

const rawApiBase = (process.env.REACT_APP_API_BASE || '').trim().replace(/\/+$/, '');
const API_BASE_URL = rawApiBase || undefined;
const city = process.env.REACT_APP_CITY_KEY;

if (typeof window !== 'undefined' && process.env.NODE_ENV === 'production') {
  if (!API_BASE_URL) {
    // eslint-disable-next-line no-console
    console.error(
      '[api] REACT_APP_API_BASE is missing. Set it in Netlify (Build env) to your HTTPS API root, e.g. https://api.movementparties.com/api — then redeploy.'
    );
  } else if (API_BASE_URL.startsWith('http:')) {
    // eslint-disable-next-line no-console
    console.warn(
      '[api] REACT_APP_API_BASE uses http:. On an https site the browser will block API calls (mixed content). Use https:// for the API URL.'
    );
  }
}

const api = axios.create({
  baseURL: API_BASE_URL,
  withCredentials: true,
  timeout: 25_000,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

/** True when the server rejected the session (vs network, 429, 5xx). */
export const isUnauthorized = (err) => err?.response?.status === 401;

api.interceptors.request.use((config) => {
  config.headers = config.headers || {};
  config.headers['X-City-Key'] = city;
  try {
    const raw = localStorage.getItem('user');
    if (raw) {
      const u = JSON.parse(raw);
      const t = u.authentication_token || u.token;
      if (t) config.headers.Authorization = `Bearer ${t}`;
    }
  } catch (_) {
    /* ignore */
  }
  return config;
});

// get all events (optional past events for archive mode — API allows for mmw + header)
export const fetchEvents = async (includePastEvents = false) => {
  const response = await api.get('/events', {
    headers: includePastEvents ? { 'X-Include-Past-Events': '1' } : {},
  });
  return response.data;
};

//get single event
export const fetchEventById = async (id) => {
  const response = await api.get(`/events/${id}`);
  return response.data;
};


//login/logout
export const userLogin = async (credentials) => {
  const response = await api.post('/login', { user: credentials });
  return response.data;
};

/** Devise recoverable — always succeeds with generic message (no email enumeration). */
export const requestPasswordReset = async (email) => {
  const { data } = await api.post('/users/password', {
    user: { email: email.trim() },
  });
  return data;
};

/** PUT /users/password with raw token from email link query param. */
export const resetPasswordWithToken = async ({
  resetPasswordToken,
  password,
  passwordConfirmation,
}) => {
  const { data } = await api.put('/users/password', {
    user: {
      reset_password_token: resetPasswordToken,
      password,
      password_confirmation: passwordConfirmation,
    },
  });
  return data;
};

export const userLogout = async () => {
  try {
    // DELETE /logout must finish before navigate or the browser may cancel the request.
    await api.delete('/logout', { timeout: 12_000 });
  } catch (e) {
    console.warn('Logout request failed or timed out; clearing client anyway.', e);
  } finally {
    localStorage.removeItem('user');
    window.location.href = '/login';
  }
};

//attending/interested event buttons
export const fetchUserEvents = async () => {
  const response = await api.get('/user_events');
  return response.data;
};

/** Self or accepted friend only (404 otherwise). Shape matches GET /user_events. */
export const fetchUserEventsForUser = async (userId) => {
  const response = await api.get(`/users/${userId}/user_events`);
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

export const deleteUserEventStatus = async (eventId) => {
  return api.delete(`/user_events/${eventId}`);
};

/** How many of your accepted friends have this event as attending / interested. */
export const fetchFriendEventCounts = async (eventId) => {
  const { data } = await api.get(`/user_events/${eventId}/friend_counts`);
  return {
    friendsAttending: data.friends_attending ?? 0,
    friendsInterested: data.friends_interested ?? 0,
  };
};

/** Batch version — one request for many event ids (string keys in response). */
export const fetchFriendEventCountsBatch = async (eventIds) => {
  const unique = [
    ...new Set((eventIds || []).filter((id) => id != null).map((id) => Number(id))),
  ].filter((n) => !Number.isNaN(n));
  if (unique.length === 0) return {};

  const { data } = await api.post('/user_events/friend_counts_batch', {
    event_ids: unique,
  });
  const raw = data.counts || {};
  const out = {};
  for (const [k, v] of Object.entries(raw)) {
    out[String(k)] = {
      friendsAttending: v.friends_attending ?? 0,
      friendsInterested: v.friends_interested ?? 0,
    };
  }
  return out;
};

/** Avatar upload — multipart; must not use axios default JSON Content-Type. */
export const uploadUserAvatar = async (file) => {
  const formData = new FormData();
  formData.append("avatar", file);
  const raw = localStorage.getItem("user");
  const u = raw ? JSON.parse(raw) : {};
  const token = u.authentication_token || u.token;
  const headers = { "X-City-Key": city };
  if (token) headers.Authorization = `Bearer ${token}`;
  const res = await fetch(`${API_BASE_URL}/user/upload_avatar`, {
    method: "POST",
    body: formData,
    credentials: "include",
    headers,
  });
  let data = {};
  try {
    data = await res.json();
  } catch (_) {
    /* ignore */
  }
  if (!res.ok) {
    const err = new Error(data.error || data.message || "Upload failed");
    err.response = { status: res.status, data };
    throw err;
  }
  return data;
};

//user profile info
/** Public-ish profile for a user id (friends only, or your own id). */
export const fetchUserPublicProfile = async (userId) => {
  const res = await api.get(`/users/${userId}`);
  return res.data;
};

export const fetchUserInfo = async () => {
  const response = await api.get('/user');
  const data = response.data;
  try {
    const raw = localStorage.getItem('user');
    const prev = raw ? JSON.parse(raw) : {};
    if (data?.authentication_token) {
      localStorage.setItem('user', JSON.stringify({ ...prev, ...data }));
    }
  } catch (_) {
    /* ignore */
  }
  return data;
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

export const searchUsers = async (q) => {
  const res = await api.get('/friendships/search', { params: { q } });
  return res.data;
};

export const fetchPendingFriendRequests = async () => {
  const res = await api.get('/friendships/pending');
  return res.data;
};

export const sendFriendRequest = async ({ username, user_id }) => {
  return api.post('/friendships', { username, user_id });
};

export const acceptFriendRequest = async (user_id) => {
  return api.post("/friendships/accept", { user_id });
};

export const cancelFriendRequest = async ({ username, user_id }) => {
  return api.delete("/friendships", { data: { username, user_id } });
};

export const rejectFriendRequest = async (user_id) => {
  return api.post("/friendships/reject", { user_id });
};


export default api;
