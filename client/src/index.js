import './setup/sentry';
import '@fortawesome/fontawesome-free/css/all.min.css';

if (process.env.REACT_APP_CITY_KEY === 'mmw') {
  require('./mmw');
} else {
  require('./movement');
}
