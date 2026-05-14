import * as Sentry from '@sentry/react';

const dsn = (process.env.REACT_APP_SENTRY_DSN || '').trim();
const sentryDisabled =
  !dsn ||
  process.env.REACT_APP_SENTRY_DISABLED === 'true' ||
  process.env.REACT_APP_SENTRY_DISABLED === '1';

if (!sentryDisabled) {
  // Prefer NODE_ENV for "production" / "development" — CRA sets it at build time.
  // Avoid REACT_APP_ENV=production in Netlify: their secrets scanner matches that string
  // across README, source maps, and node_modules (false positives).
  const sentryEnvironment =
    process.env.REACT_APP_ENV ||
    process.env.NODE_ENV ||
    'development';

  Sentry.init({
    dsn,
    environment: sentryEnvironment,
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
}
