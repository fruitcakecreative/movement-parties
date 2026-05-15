import { useLocation } from 'react-router-dom';
import FacebookLogin from 'react-facebook-login';
import { loginWithFacebook } from '../../services/api';

/**
 * Optional: set on Netlify to the exact origin you whitelist in Meta (e.g. https://movementparties.com).
 * Must match “Valid OAuth Redirect URIs” for each path you use (/login, /signup) when Strict Mode is on.
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

/** Login scopes only — `user_friends` is not valid on Facebook Login for most apps (Meta rejects it in the dialog). */
const FB_LOGIN_SCOPE = 'public_profile,email';

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
        'Facebook could not complete sign-in. Add this site’s URL under Meta → App → Facebook Login → Settings (Valid OAuth Redirect URIs). If the app is still in Development mode, only invited testers can sign in—or use email below.'
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
