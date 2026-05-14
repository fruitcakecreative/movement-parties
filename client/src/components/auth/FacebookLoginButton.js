import { useLocation } from 'react-router-dom';
import FacebookLogin from 'react-facebook-login';
import { loginWithFacebook } from '../../services/api';

/**
 * Optional: set on Netlify to the exact origin you whitelist in Meta (e.g. https://movementparties.com).
 * Avoids www vs apex mismatch on /signup and /login when Strict Mode redirect URIs are enabled.
 * Omit on localhost so dev still uses the current origin.
 */
const FB_REDIRECT_ORIGIN = (process.env.REACT_APP_FACEBOOK_REDIRECT_ORIGIN || '').replace(
  /\/+$/,
  ''
);

function redirectOriginForOAuth() {
  if (typeof window === 'undefined') {
    return FB_REDIRECT_ORIGIN;
  }
  const host = window.location.hostname;
  const isLocal = host === 'localhost' || host === '127.0.0.1';
  if (FB_REDIRECT_ORIGIN && !isLocal) {
    return FB_REDIRECT_ORIGIN;
  }
  return window.location.origin;
}

/** OAuth redirect must match Meta “Valid OAuth Redirect URIs” exactly — no query or hash. */
function redirectUriFromPathname(pathname) {
  if (typeof window === 'undefined') return '';
  let path = pathname || '/';
  if (path.length > 1 && path.endsWith('/')) {
    path = path.slice(0, -1);
  }
  return `${redirectOriginForOAuth()}${path}`;
}

const FB_APP_ID =
  process.env.REACT_APP_FB_APP_ID || process.env.REACT_APP_FACEBOOK_APP_ID || '';

/** Graph `user_friends`: only friends who also use this same Meta app (not your whole FB friends list). */
const FB_LOGIN_SCOPE = 'public_profile,email,user_friends';

/**
 * One successful `/me/friends` call satisfies Meta’s “API test” for `user_friends` while Facebook Login is in testing.
 * Uses the session from the login that just completed; does not block sign-in if it fails.
 */
function callFacebookAppFriendsList() {
  if (typeof window === 'undefined' || !window.FB?.api) {
    return Promise.resolve(null);
  }
  return new Promise((resolve) => {
    window.FB.api('/me/friends', { fields: 'id,name' }, (res) => {
      if (res?.error) {
        // eslint-disable-next-line no-console
        console.warn('Facebook /me/friends:', res.error);
      }
      resolve(res);
    });
  });
}

function FacebookLoginButton({
  textButton = 'Continue with Facebook',
  onFacebookNotice,
}) {
  const { pathname } = useLocation();
  const redirectUri = redirectUriFromPathname(pathname);

  const handleFacebookCallback = async (response) => {
    onFacebookNotice?.('');

    if (response?.error) {
      onFacebookNotice?.(
        response.error_message ||
          response.errorMessage ||
          response.error_description ||
          response.errorDescription ||
          response.error ||
          'Facebook sign-in did not complete. You can try again or use email below.'
      );
      return;
    }

    if (response?.status === 'unknown') {
      onFacebookNotice?.(
        'Facebook could not complete sign-in. If the Meta app is still in development, only invited testers can use this—or use email below.'
      );
      // eslint-disable-next-line no-console
      console.error('Facebook login cancelled or failed.');
      return;
    }

    if (!response?.email) {
      onFacebookNotice?.(
        'Facebook did not share an email for this account. Use email sign-up below, or allow email in the Facebook permission screen.'
      );
      return;
    }

    await callFacebookAppFriendsList();

    const userData = {
      name: response.name,
      email: response.email,
      picture: response.picture?.data?.url,
    };

    try {
      const data = await loginWithFacebook(userData);
      if (data.user) {
        const u = data.user;
        localStorage.setItem(
          'user',
          JSON.stringify({
            ...u,
            authentication_token: u.authentication_token || u.token,
          })
        );
        window.location.href = '/profile';
        return;
      }
      onFacebookNotice?.(
        typeof data?.error === 'string' && data.error.trim()
          ? data.error.trim()
          : 'Could not finish creating your account. Try email sign-up below.'
      );
    } catch (err) {
      onFacebookNotice?.('Network error reaching the server. Try again in a moment.');
      // eslint-disable-next-line no-console
      console.error('Facebook login failed:', err);
    }
  };

  if (!FB_APP_ID) {
    return null;
  }

  return (
    <FacebookLogin
      textButton={textButton}
      buttonStyle={{ padding: '6px' }}
      appId={FB_APP_ID}
      autoLoad={false}
      fields="name,email,picture.width(400).height(400)"
      scope={FB_LOGIN_SCOPE}
      callback={handleFacebookCallback}
      /* Default Graph version was v2.3 (removed) — use a current version or Meta shows “login unavailable”. */
      version="20.0"
      cookie
      /* Mobile default uses full window.location.href as redirect_uri (UTMs etc.) → whitelist errors. */
      redirectUri={redirectUri}
      /* Prefer JS SDK login on phones so we are not tied to every possible redirect URL. */
      disableMobileRedirect
    />
  );
}

export default FacebookLoginButton;
