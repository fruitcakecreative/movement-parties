/**
 * SPA auth uses Bearer tokens in localStorage (see ApplicationController).
 * Session cookies alone are not enough — always persist token after /user succeeds.
 */

export function readStoredUser() {
  try {
    const raw = localStorage.getItem('user');
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

/** Merge API user payload into localStorage and normalize authentication_token. */
export function persistAuthUser(apiUser) {
  if (!apiUser || typeof apiUser !== 'object') return;
  const prev = readStoredUser() || {};
  const token =
    apiUser.authentication_token || apiUser.token || prev.authentication_token || prev.token;
  if (!token) return;
  localStorage.setItem(
    'user',
    JSON.stringify({
      ...prev,
      ...apiUser,
      profile_extra:
        apiUser.profile_extra != null && typeof apiUser.profile_extra === 'object'
          ? apiUser.profile_extra
          : {},
      authentication_token: token,
      token,
    })
  );
}

export function hasAuthToken() {
  const u = readStoredUser();
  return !!(u?.authentication_token || u?.token);
}

export function readAuthToken() {
  const u = readStoredUser();
  return u?.authentication_token || u?.token || null;
}
