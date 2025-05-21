function PrivacyPolicy() {
  return (
    <div style={{ padding: "2rem", maxWidth: "700px", margin: "0 auto" }}>
      <h1>Privacy Policy</h1>
      <p>
        <strong>Movement Parties</strong> respects your privacy. When you log in with Facebook, we collect your public profile information (name, email, and profile picture) to create your user account.
      </p>
      <p>
        If you choose to connect with Facebook friends, we access only the list of friends who also use the app. This is used for suggesting friends and is not permanently stored.
      </p>
      <p>
        We do not sell or share your data with third parties. You may delete your account at any time by contacting us at <a href="mailto:support@movementparties.com">support@movementparties.com</a>.
      </p>
      <p><strong>Updated:</strong> {new Date().toLocaleDateString()}</p>
    </div>
  );
}

export default PrivacyPolicy;
