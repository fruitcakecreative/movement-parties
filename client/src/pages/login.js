import { useState, useEffect } from "react";
import { userLogin } from "../services/api";
import { fetchUserInfo } from "../services/api";


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

  if (checkSession) return null;


  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const data = await userLogin({ email, password });
      if (data.user) {
        window.location.href = "/profile";
      }
    } catch (err) {
      console.error("Login failed:", err);
      setError("Invalid email or password");
    }
  };


  return (
    <>
    <form onSubmit={handleSubmit} style={{ padding: '2rem' }}>
      <h2>Login</h2>
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
    <br/>
      {error && <p style={{ color: "red" }}>{error}</p>}
      <button type="submit">Login</button>
    </form>
    </>
  );
}

export default Login;
