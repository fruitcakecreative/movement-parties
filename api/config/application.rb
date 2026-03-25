require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)
Dotenv::Railtie.load if defined?(Dotenv)

module MovementParties
  class Application < Rails::Application
    config.load_defaults 7.2

    config.api_only = false

    config.middleware.use Rack::Attack
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
    # Optional: set SESSION_COOKIE_DOMAIN e.g. ".movementparties.com" so the same session is sent
    # to api.* and www.* (Rails Admin + SPA + API must share parent domain for this to apply).
    session_cookie_opts = {
      key: "_movement_parties_session",
      same_site: Rails.env.production? ? :none : :lax,
      secure: Rails.env.production?,
      expire_after: 14.days
    }
    session_cookie_opts[:domain] = ENV["SESSION_COOKIE_DOMAIN"].presence if ENV["SESSION_COOKIE_DOMAIN"].present?
    config.middleware.use ActionDispatch::Session::CookieStore, session_cookie_opts

    config.autoload_lib(ignore: %w[assets])
  end
end
