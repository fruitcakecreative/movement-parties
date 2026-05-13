import { useState } from "react";
import { Link } from "react-router-dom";
import { requestPasswordReset } from "../services/api";

function ForgotPassword() {
  const [email, setEmail] = useState("");
  const [done, setDone] = useState(false);
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setSubmitting(true);
    try {
      await requestPasswordReset(email);
      setDone(true);
    } catch (err) {
      const raw = err?.response?.data;
      const msg = Array.isArray(raw?.errors)
        ? raw.errors.join(" ")
        : raw?.error || "Something went wrong. Try again.";
      setError(msg);
    } finally {
      setSubmitting(false);
    }
  };

  if (done) {
    return (
      <section className="auth-page" aria-labelledby="forgot-done-heading">
        <div className="auth-page__card">
          <h1 id="forgot-done-heading" className="auth-page__title">
            Check your email
          </h1>
          <p className="auth-page__lede">
            If that address is registered, we sent a link to reset your password. It
            expires in a few hours.
          </p>
          <p className="auth-page__success" role="status">
            You can close this tab, then use the link from your inbox when you are
            ready.
          </p>
          <p className="auth-page__switch auth-page__switch--no-rule">
            <Link to="/login">Back to log in</Link>
          </p>
        </div>
      </section>
    );
  }

  return (
    <section className="auth-page" aria-labelledby="forgot-heading">
      <div className="auth-page__card">
        <h1 id="forgot-heading" className="auth-page__title">
          Reset your password
        </h1>
        <p className="auth-page__lede">
          Enter the email you use for this site. We will send you a link to choose a
          new password.
        </p>

        <form className="auth-page__form" onSubmit={handleSubmit} noValidate>
          <div className="auth-page__field">
            <label htmlFor="forgot-email">Email</label>
            <input
              id="forgot-email"
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

          {error && (
            <p className="auth-page__error" role="alert">
              {error}
            </p>
          )}

          <button
            type="submit"
            className="button button--lg button--full auth-page__submit"
            disabled={submitting}
          >
            {submitting ? "Sending…" : "Send reset link"}
          </button>
        </form>

        <p className="auth-page__switch">
          <Link to="/login">Back to log in</Link>
        </p>
      </div>
    </section>
  );
}

export default ForgotPassword;
