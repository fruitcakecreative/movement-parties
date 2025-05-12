import * as Sentry from '@sentry/react';

Sentry.init({
  dsn: 'https://a0d55299eb711f8afc2d33676cfa2980@o4509307444264960.ingest.us.sentry.io/4509307445444608',
  environment: process.env.REACT_APP_ENV || 'development',
  release: process.env.REACT_APP_RELEASE,
  sendDefaultPii: true,
  integrations: [Sentry.browserTracingIntegration()],
  tracesSampleRate: 1.0,
  tracePropagationTargets: ['localhost', /^https:\/\/movement-parties\.onrender\.com\/api/],
});
