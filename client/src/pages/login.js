import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { userLogin, fetchUserInfo } from "../services/api";
import FacebookLoginButton from "../components/auth/FacebookLoginButton";

function Login() {
  const [checkSession, setCheckSession] = useState(true);

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  useEffect(() => {
    fetchUserInfo()
      .then(() => {
        window.location.href = "/profile";
      })
      .catch(() => {
        setCheckSession(false);
      });
  }, []);

  if (checkSession) {
    return (
      <div className="auth-page__loading" aria-live="polite">
        Checking session…
      </div>
    );
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    try {
      const data = await userLogin({ email, password });
      if (data.user) {
        const u = data.user;
        localStorage.setItem(
          "user",
          JSON.stringify({
            ...u,
            authentication_token: u.authentication_token || u.token,
          })
        );
        window.location.href = "/profile";
      }
    } catch (err) {
      console.error("Login failed:", err);
      setError("Invalid email or password");
    }
  };

  return (
    <section className="auth-page" aria-labelledby="login-heading">
      <div className="auth-page__card">
        <h1 id="login-heading" className="auth-page__title">
          Welcome back
        </h1>
        <p className="auth-page__lede">
          Log in to save events, and see friends’ plans.
        </p>

        <div className="auth-page__social">
          <FacebookLoginButton onFacebookNotice={setError} />
        </div>

        {error && (
          <p className="auth-page__error" role="alert">
            {error}
          </p>
        )}

        <div className="auth-page__divider" aria-hidden="true">
          <span>or email</span>
        </div>

        <form className="auth-page__form" onSubmit={handleSubmit} noValidate>
          <div className="auth-page__field">
            <label htmlFor="login-email">Email</label>
            <input
              id="login-email"
              name="email"
              type="email"
              className="auth-page__input"
              placeholder="you@example.com"
              autoComplete="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div className="auth-page__field">
            <label htmlFor="login-password">Password</label>
            <input
              id="login-password"
              name="password"
              type="password"
              className="auth-page__input"
              placeholder="••••••••"
              autoComplete="current-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
            <p className="auth-page__forgot">
              <Link to="/forgot-password">Forgot password?</Link>
            </p>
          </div>

          <button
            type="submit"
            className="button button--lg button--full auth-page__submit"
          >
            Log in
          </button>
        </form>

        <p className="auth-page__switch">
          No account yet? <Link to="/signup">Create one</Link>
        </p>
      </div>
    </section>
  );
}

export default Login;
