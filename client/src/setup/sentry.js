import * as Sentry from '@sentry/react';

Sentry.init({
  dsn: process.env.REACT_APP_SENTRY_DSN,
  environment: process.env.REACT_APP_ENV || 'development',
  release: process.env.REACT_APP_RELEASE,
  sendDefaultPii: true,
  integrations: [
    Sentry.replayIntegration(),
    Sentry.browserTracingIntegration(),
  ],
  tracesSampleRate: 1.0,
  replaysSessionSampleRate: 1.0,
  replaysOnErrorSampleRate: 1.0,
  tracePropagationTargets: ['localhost', 'stagingapi.movementparties.com', 'api.movementparties.com'],
});
