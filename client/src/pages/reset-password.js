import { useState, useMemo } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { resetPasswordWithToken } from "../services/api";

function formatErrors(data) {
  if (!data || typeof data !== "object") return "Could not reset password. Try again.";
  if (Array.isArray(data.errors) && data.errors.length) {
    return data.errors.join(" ");
  }
  if (typeof data.error === "string" && data.error.trim()) {
    return data.error.trim();
  }
  return "Could not reset password. Request a new link and try again.";
}

function ResetPassword() {
  const [searchParams] = useSearchParams();
  const token = useMemo(
    () => searchParams.get("reset_password_token")?.trim() || "",
    [searchParams]
  );

  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const missingToken = !token;

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    if (missingToken) return;

    setSubmitting(true);
    try {
      const data = await resetPasswordWithToken({
        resetPasswordToken: token,
        password,
        passwordConfirmation,
      });
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
        return;
      }
      setError("Unexpected response from server.");
    } catch (err) {
      const data = err?.response?.data;
      setError(formatErrors(data));
    } finally {
      setSubmitting(false);
    }
  };

  if (missingToken) {
    return (
      <section className="auth-page" aria-labelledby="reset-missing-heading">
        <div className="auth-page__card">
          <h1 id="reset-missing-heading" className="auth-page__title">
            Invalid or expired link
          </h1>
          <p className="auth-page__lede">
            This reset link is missing a token, or it was copied incorrectly. Request a
            fresh email from the forgot-password page.
          </p>
          <p className="auth-page__switch auth-page__switch--no-rule">
            <Link to="/forgot-password">Request a new link</Link>
            {" · "}
            <Link to="/login">Log in</Link>
          </p>
        </div>
      </section>
    );
  }

  return (
    <section className="auth-page" aria-labelledby="reset-heading">
      <div className="auth-page__card">
        <h1 id="reset-heading" className="auth-page__title">
          Choose a new password
        </h1>
        <p className="auth-page__lede">
          Enter a new password below. After you save, you will be signed in
          automatically.
        </p>

        <form className="auth-page__form" onSubmit={handleSubmit} noValidate>
          <div className="auth-page__field">
            <label htmlFor="reset-password">New password</label>
            <input
              id="reset-password"
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
            <label htmlFor="reset-password-confirm">Confirm new password</label>
            <input
              id="reset-password-confirm"
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
            {submitting ? "Saving…" : "Update password"}
          </button>
        </form>

        <p className="auth-page__switch">
          <Link to="/login">Back to log in</Link>
        </p>
      </div>
    </section>
  );
}

export default ResetPassword;
