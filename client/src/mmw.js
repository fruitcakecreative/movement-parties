import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import * as Sentry from '@sentry/react';
import reportWebVitals from './setup/reportWebVitals';

import './styles/index.css';
import './styles/shared/index.scss';
import './styles/themes/mmw.scss';

document.documentElement.setAttribute('data-site', 'mmw');

Sentry.startSpan({ name: 'pageload', op: 'pageload' }, () => {
  const root = ReactDOM.createRoot(document.getElementById('root'));
  root.render(
    <React.StrictMode>
      <App />
      <div id="modal-root"></div>
    </React.StrictMode>
  );
});

reportWebVitals((metric) =>
  Sentry.captureMessage(JSON.stringify(metric), { level: 'info' })
);
