import './setup/sentry';
import '@fortawesome/fontawesome-free/css/all.min.css';

console.log("SITE KEY:", process.env.REACT_APP_CITY_KEY);

if (process.env.REACT_APP_CITY_KEY === "mmw") {
  console.log("miami music week!");
  require('./mmw');
} else {
  console.log("movement !");
  require('./movement');
}
