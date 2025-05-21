import { useState } from "react";
import FacebookLoginButton from "../components/auth/FacebookLoginButton"

function Signup() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");

  const handleSubmit = async (e) => {
  e.preventDefault();

  const res = await fetch("http://localhost:3001/api/users", {
      method: "POST",
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

    const data = await res.json();
    console.log("Response:", res.status, data);

    if (res.ok && data.user) {
      localStorage.setItem("user", JSON.stringify(data.user));
      window.location.href = "/profile";
    }
  };


  return (
    <form onSubmit={handleSubmit} style={{ padding: "2rem" }}>
      <h2>Sign Up</h2>
      <FacebookLoginButton text="Sign Up With Facebook"/>
        <input
          type="text"
          placeholder="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
        <br />
      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />
      <br />
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <br />
      <input
        type="password"
        placeholder="Confirm Password"
        value={passwordConfirmation}
        onChange={(e) => setPasswordConfirmation(e.target.value)}
        required
      />
      <br />
      <button type="submit">Sign Up</button>
    </form>
  );
}

export default Signup;
