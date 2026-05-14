require "active_support/core_ext/integer/time"

Rails.application.configure do

  config.enable_reloading = false

  config.hosts << "api.movementparties.com"
  config.hosts << "movement-parties-3hop.onrender.com"

  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.cache_store = :memory_store

  # config.active_storage.service = :local
  config.active_storage.service = :amazon


  config.force_ssl = true

  logger = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = proc do |severity, datetime, _progname, msg|
    "[RAILS] #{datetime.utc.iso8601} #{severity}: #{msg}\n"
  end

  config.logger = ActiveSupport::TaggedLogging.new(logger)

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]


  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")


  config.action_mailer.perform_caching = false

  # Postmark (https://postmarkapp.com): set POSTMARK_API_TOKEN and MAILER_FROM (verified sender in Postmark).
  if ENV["POSTMARK_API_TOKEN"].present?
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { api_token: ENV["POSTMARK_API_TOKEN"] }
    # Avoid 500 on failed sends (invalid token, unverified sender, etc.); check logs / Postmark activity.
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.perform_deliveries = true
    config.action_mailer.default_url_options = {
      host: ENV.fetch("ACTION_MAILER_DEFAULT_HOST", "api.movementparties.com"),
      protocol: "https",
    }
    if (from = ENV["MAILER_FROM"].presence)
      config.action_mailer.default_options = { from: from }
    end
  else
    config.action_mailer.perform_deliveries = false
    config.action_mailer.raise_delivery_errors = false
  end

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Password reset emails link to the SPA; set CLIENT_ORIGIN (e.g. https://movementparties.com).
  # Configure Action Mailer (SMTP, Postmark, etc.) so reset emails actually send.
end
