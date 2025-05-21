import './setup/sentry';
import React from 'react';
import ReactDOM from 'react-dom/client';
import './styles/index.css';
import App from './App';
import * as Sentry from '@sentry/react';
import reportWebVitals from './setup/reportWebVitals';
import '@fortawesome/fontawesome-free/css/all.min.css';

Sentry.startSpan({ name: 'pageload', op: 'pageload' }, () => {
  const root = ReactDOM.createRoot(document.getElementById('root'));
  root.render(
    <React.StrictMode>
      <App />
      <div id="modal-root"></div>
    </React.StrictMode>
  );
});



reportWebVitals((metric) => Sentry.captureMessage(JSON.stringify(metric), { level: 'info' }));
