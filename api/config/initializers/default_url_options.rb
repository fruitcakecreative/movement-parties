# Default host for URL helpers outside a request (Venue#logo_url, mailers, etc.).
# Align development with client .env (REACT_APP_API_BASE): usually http://localhost:3000/api
#
# Production: set ACTIVE_STORAGE_PUBLIC_HOST if the API is not api.movementparties.com
# (e.g. Render URL only) so logo URLs in JSON match a host your CDN/browser can reach.
case Rails.env
when "development"
  Rails.application.routes.default_url_options = {
    host: ENV.fetch("ACTIVE_STORAGE_PUBLIC_HOST", "localhost"),
    port: ENV.fetch("ACTIVE_STORAGE_PUBLIC_PORT", 3000).to_i,
    protocol: ENV.fetch("ACTIVE_STORAGE_PUBLIC_PROTOCOL", "http")
  }
when "staging"
  Rails.application.routes.default_url_options = {
    host: ENV.fetch("ACTIVE_STORAGE_PUBLIC_HOST", "stagingapi.movementparties.com"),
    protocol: "https"
  }
when "production"
  Rails.application.routes.default_url_options = {
    host: ENV.fetch("ACTIVE_STORAGE_PUBLIC_HOST", "api.movementparties.com"),
    protocol: "https"
  }
when "test"
  Rails.application.routes.default_url_options = {
    host: "www.example.com",
    protocol: "http"
  }
end

if %w[development staging production test].include?(Rails.env)
  Rails.application.config.action_controller.default_url_options =
    Rails.application.routes.default_url_options.dup
end
