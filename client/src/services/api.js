import axios from 'axios';
import { persistAuthUser, readAuthToken } from '../utils/authStorage';
import { normalizeEventId } from '../utils/eventId';
import { normalizeProfileExtra, profileExtraForApi } from '../utils/profileExtraInfo';

const API_BASE_URL = process.env.REACT_APP_API_BASE;
const city = process.env.REACT_APP_CITY_KEY;

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
  const t = readAuthToken();
  if (t) config.headers.Authorization = `Bearer ${t}`;
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
  if (response.data?.user) persistAuthUser(response.data.user);
  return response.data;
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

/** Devise recoverable — generic success body (no email enumeration). SPA link uses CLIENT_ORIGIN on API. */
export const requestPasswordReset = async (email) => {
  const { data } = await api.post('/password', {
    user: { email: String(email).trim() },
  });
  return data;
};

/** PUT /api/password — raw token from email; response may include authentication_token for Bearer API calls. */
export const resetPasswordWithToken = async ({
  resetPasswordToken,
  password,
  passwordConfirmation,
}) => {
  const { data } = await api.put('/password', {
    user: {
      reset_password_token: resetPasswordToken,
      password,
      password_confirmation: passwordConfirmation,
    },
  });
  if (data?.user) persistAuthUser(data.user);
  return data;
};

//attending/interested event buttons
export const fetchUserEvents = async () => {
  const response = await api.get('/user_events');
  return response.data;
};

/** Friend’s saved events (same shape as fetchUserEvents) — self or accepted friend only. */
export const fetchUserEventsForUser = async (userId) => {
  const response = await api.get(`/users/${userId}/user_events`);
  return response.data;
};

export const saveUserEventStatus = async (eventId, status) => {
  const id = normalizeEventId(eventId);
  if (id == null) {
    throw new Error('Invalid event id');
  }
  return api.post('/user_events', {
    user_event: {
      event_id: id,
      status: String(status),
    },
  });
};

export const deleteUserEventStatus = async (eventId) => {
  const id = normalizeEventId(eventId);
  if (id == null) {
    throw new Error('Invalid event id');
  }
  return api.delete('/user_events', {
    data: { user_event: { event_id: id } },
  });
};

/** How many accepted friends have this event as attending / interested. */
export const fetchFriendEventCounts = async (eventId) => {
  const { data } = await api.get(`/user_events/${eventId}/friend_counts`);
  return {
    friendsAttending: data.friends_attending ?? 0,
    friendsInterested: data.friends_interested ?? 0,
  };
};

/** Batch friend counts for many event ids (string keys in response). */
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

/** How many users (any account) saved this event as interested or attending. */
export const fetchEventRsvpTotals = async (eventId) => {
  const id = Number(eventId);
  if (!id) return { interested: 0, attending: 0 };
  try {
    const { data } = await api.get(`/events/${id}/rsvp_totals`);
    return {
      interested: data.app_interested_count ?? 0,
      attending: data.app_attending_count ?? 0,
    };
  } catch (e) {
    return { interested: 0, attending: 0 };
  }
};

/** Accepted friends attending + interested for event detail UI. */
export const fetchFriendEventRsvps = async (eventId) => {
  const id = Number(eventId);
  if (!id) return { attending: [], interested: [] };
  try {
    const { data } = await api.get(`/user_events/${id}/friend_rsvps`);
    return {
      attending: Array.isArray(data.attending) ? data.attending : [],
      interested: Array.isArray(data.interested) ? data.interested : [],
    };
  } catch (e) {
    if (e?.response?.status === 401 || e?.response?.status === 403) {
      return { attending: [], interested: [] };
    }
    throw e;
  }
};

//user profile info
export const fetchUserInfo = async () => {
  const response = await api.get('/user');
  const data = {
    ...response.data,
    profile_extra: normalizeProfileExtra(response.data?.profile_extra),
  };
  persistAuthUser(data);
  return data;
};

/** PATCH /user — display name (`name`), email, and/or optional profile_extra fields. */
export const updateCurrentUser = async ({ name, email, profile_extra }) => {
  const user = {};
  if (name != null) user.name = String(name).trim();
  if (email != null) user.email = String(email).trim();
  if (profile_extra != null) user.profile_extra = profileExtraForApi(profile_extra);

  const { data } = await api.patch('/user', { user });
  const normalized = {
    ...data,
    profile_extra: normalizeProfileExtra(data?.profile_extra),
  };
  persistAuthUser(normalized);
  return normalized;
};

/** Another member’s profile — self or accepted friend only (404 otherwise). */
export const fetchUserPublicProfile = async (userId) => {
  const response = await api.get(`/users/${userId}`);
  return response.data;
};

/** Accepted friends of `userId` (no emails). You must be that user or their accepted friend. */
export const fetchFriendsOfUser = async (userId) => {
  const { data } = await api.get(`/users/${userId}/friends`);
  return Array.isArray(data) ? data : [];
};

/** Avatar upload — multipart; must not use axios default JSON Content-Type. */
export const uploadUserAvatar = async (file) => {
  const formData = new FormData();
  formData.append('avatar', file);
  const token = readAuthToken();
  const base = (API_BASE_URL || '').replace(/\/+$/, '');
  const headers = { 'X-City-Key': city };
  if (token) headers.Authorization = `Bearer ${token}`;
  const res = await fetch(`${base}/user/upload_avatar`, {
    method: 'POST',
    headers,
    body: formData,
    credentials: 'include',
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) {
    const err = new Error(data.error || 'Upload failed');
    err.response = { data, status: res.status };
    throw err;
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

  const data = await res.json();
  if (data?.user) persistAuthUser(data.user);
  return data;
};

export const fetchAllUsers = async () => {
  const res = await api.get('/users');
  return res.data;
};

export const fetchFriendshipList = async () => {
  const res = await api.get('/friendships');
  return res.data;
};

export const fetchPendingFriendRequests = async () => {
  const res = await api.get('/friendships/pending');
  return res.data;
};

export const searchUsers = async (q) => {
  const res = await api.get('/friendships/search', { params: { q } });
  return res.data;
};

/** `username` string or `{ username?, user_id? }` */
export const sendFriendRequest = async (usernameOrPayload) => {
  const body =
    typeof usernameOrPayload === 'string'
      ? { username: usernameOrPayload }
      : usernameOrPayload;
  return api.post('/friendships', body);
};

export const acceptFriendRequest = async (user_id) => {
  return api.post('/friendships/accept', { user_id });
};

/** `{ user_id }` preferred, or legacy string `username` */
export const cancelFriendRequest = async (payload) => {
  const body =
    payload != null && typeof payload === 'object' && payload.user_id != null
      ? { user_id: payload.user_id }
      : typeof payload === 'string'
        ? { username: payload }
        : payload;
  return api.delete('/friendships', { data: body });
};

export const rejectFriendRequest = async (user_id) => {
  return api.post('/friendships/reject', { user_id });
};

export default api;
