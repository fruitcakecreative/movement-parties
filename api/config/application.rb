require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)
Dotenv::Railtie.load if defined?(Dotenv)

module MovementParties
  class Application < Rails::Application
    config.load_defaults 7.2

    config.api_only = false

    # Rack::Attack is inserted by the gem's Railtie — do not add middleware.use Rack::Attack here
    # or throttles run twice per request.

    # Configure the ONE session store Rails uses. Do not add ActionDispatch::Session::CookieStore
    # via middleware.use — that stacks a second store on top of the default and breaks sessions
    # (every request looks logged out).
    session_opts = {
      key: "_movement_parties_session",
      same_site: Rails.env.production? ? :none : :lax,
      secure: Rails.env.production?,
      expire_after: 14.days
    }
    session_opts[:domain] = ENV["SESSION_COOKIE_DOMAIN"] if ENV["SESSION_COOKIE_DOMAIN"].present?
    config.session_store :cookie_store, **session_opts

    config.autoload_lib(ignore: %w[assets])
  end
end
