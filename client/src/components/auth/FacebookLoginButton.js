import FacebookLogin from 'react-facebook-login';
import { loginWithFacebook } from "../../services/api";

const FacebookLoginButton = (props) => {

  const handleFacebookCallback = async (response) => {

    console.log(response);
    if (response?.status === "unknown") {
        console.error('Sorry!', 'Something went wrong with facebook Login.');
     return;
    }

        const userData = {
          name: response.name,
          email: response.email,
          picture: response.picture.data.url
        };

        try {
          const data = await loginWithFacebook(userData);
          if (data.user) {
            localStorage.setItem("user", JSON.stringify(data.user));
            window.location.href = "/profile";
          }
        } catch (err) {
          console.error("Facebook login failed:", err);
        }
  }

  return (
    <FacebookLogin
      buttonStyle={{padding:"6px"}}
      appId="1371232790678843"
      autoLoad={false}
      fields="name,email,picture.width(400).height(400)"
      callback={handleFacebookCallback} />
  );
};

export default FacebookLoginButton;
