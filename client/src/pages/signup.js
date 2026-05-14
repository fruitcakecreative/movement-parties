import { useState } from "react";
import { Link } from "react-router-dom";
import FacebookLoginButton from "../components/auth/FacebookLoginButton";

function formatSignupErrors(data) {
  if (!data || typeof data !== "object") return "Something went wrong. Try again.";
  if (Array.isArray(data.errors) && data.errors.length) {
    return data.errors.join(" ");
  }
  if (typeof data.error === "string" && data.error.trim()) {
    return data.error.trim();
  }
  return "Could not create account. Check your details and try again.";
}

function Signup() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    setSubmitting(true);
    try {
      const res = await fetch(`${process.env.REACT_APP_API_BASE}/users`, {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          user: {
            name,
            email,
            password,
            password_confirmation: passwordConfirmation,
          },
        }),
      });

      const data = await res.json().catch(() => ({}));

      if (res.ok && data.user) {
        const u = data.user;
        localStorage.setItem(
          "user",
          JSON.stringify({
            ...u,
            authentication_token: u.authentication_token || u.token,
          })
        );
        window.location.href = "/profile";
        return;
      }

      setError(formatSignupErrors(data));
    } catch {
      setError("Network error. Check your connection and try again.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <section className="auth-page" aria-labelledby="signup-heading">
      <div className="auth-page__card auth-page__card--register">
        <h1 id="signup-heading" className="auth-page__title">
          Create an account
        </h1>
        <p className="auth-page__lede">
          Join to save events, connect with friends, and keep your party plans in sync.
        </p>

        <div className="auth-page__social">
          <FacebookLoginButton
            textButton="Sign up with Facebook"
            onFacebookNotice={setError}
          />
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
            <label htmlFor="signup-name">Name</label>
            <input
              id="signup-name"
              name="name"
              type="text"
              className="auth-page__input"
              placeholder="Your name"
              autoComplete="name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
          </div>
          <div className="auth-page__field">
            <label htmlFor="signup-email">Email</label>
            <input
              id="signup-email"
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
            <label htmlFor="signup-password">Password</label>
            <input
              id="signup-password"
              name="password"
              type="password"
              className="auth-page__input"
              placeholder="At least 6 characters"
              autoComplete="new-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              minLength={6}
            />
          </div>
          <div className="auth-page__field">
            <label htmlFor="signup-password-confirm">Confirm password</label>
            <input
              id="signup-password-confirm"
              name="password_confirmation"
              type="password"
              className="auth-page__input"
              placeholder="Repeat password"
              autoComplete="new-password"
              value={passwordConfirmation}
              onChange={(e) => setPasswordConfirmation(e.target.value)}
              required
            />
          </div>

          <button
            type="submit"
            className="button button--lg button--full auth-page__submit"
            disabled={submitting}
          >
            {submitting ? "Creating account…" : "Sign up"}
          </button>
        </form>

        <p className="auth-page__switch">
          Already have an account? <Link to="/login">Log in</Link>
        </p>
      </div>
    </section>
  );
}

export default Signup;
