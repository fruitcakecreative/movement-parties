require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)
Dotenv::Railtie.load if defined?(Dotenv)

module MovementParties
  class Application < Rails::Application
    config.load_defaults 7.2

    config.api_only = false

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
    config.middleware.use PrometheusExporter::Middleware
    config.middleware.use ActionDispatch::Session::CookieStore,
      key: "_movement_parties_session",
      same_site: Rails.env.production? ? :none : :lax,
      secure: Rails.env.production?

    config.autoload_lib(ignore: %w[assets])
  end
end
