const { createProxyMiddleware } = require('http-proxy-middleware');

/**
 * Rails Admin and Active Storage live on the API (see repo ./bin/dev — API :3001, client :3000).
 * Without this, http://localhost:3000/admin/* is handled by CRA’s history fallback and serves the
 * React shell; relative /assets and /rails URLs then misroute or stall.
 *
 * Target: override with API_PROXY_TARGET=http://127.0.0.1:PORT if your API port differs.
 */
module.exports = function setupProxy(devServerApp) {
  const target = process.env.API_PROXY_TARGET || 'http://localhost:3001';
  const common = { target, changeOrigin: true, logLevel: 'warn' };

  devServerApp.use('/admin', createProxyMiddleware({ ...common }));
  devServerApp.use('/rails', createProxyMiddleware({ ...common }));
  devServerApp.use('/assets', createProxyMiddleware({ ...common }));
};
