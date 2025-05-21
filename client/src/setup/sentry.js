import * as Sentry from '@sentry/react';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.REACT_APP_ENV || 'development',
  release: process.env.REACT_APP_RELEASE,
  sendDefaultPii: true,
  integrations: [
    Sentry.browserTracingIntegration(),
    Sentry.replayIntegration()
  ],
  replaysSessionSampleRate: 1.0,
  replaysOnErrorSampleRate: 1.0,
  tracesSampleRate: 1.0,
  tracePropagationTargets: ['localhost', 'https://stagingapi.movementparties.com', 'https://api.movementparties.com'],
});
