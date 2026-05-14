import { useMemo } from 'react';
import { useLocation } from 'react-router-dom';
import FacebookLogin from 'react-facebook-login';
import { loginWithFacebook } from '../../services/api';

/** OAuth redirect must match Meta “Valid OAuth Redirect URIs” exactly — no query or hash. */
function canonicalFacebookRedirectUri() {
  if (typeof window === 'undefined') return '';
  let path = window.location.pathname || '/';
  if (path.length > 1 && path.endsWith('/')) {
    path = path.slice(0, -1);
  }
  return `${window.location.origin}${path}`;
}

const FB_APP_ID =
  process.env.REACT_APP_FB_APP_ID || process.env.REACT_APP_FACEBOOK_APP_ID || '';

function FacebookLoginButton({ textButton = 'Continue with Facebook' }) {
  const location = useLocation();
  const redirectUri = useMemo(
    () => canonicalFacebookRedirectUri(),
    [location.pathname]
  );

  const handleFacebookCallback = async (response) => {
    if (response?.status === 'unknown') {
      // eslint-disable-next-line no-console
      console.error('Facebook login cancelled or failed.');
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
      }
    } catch (err) {
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
