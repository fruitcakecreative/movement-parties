require "active_support/core_ext/integer/time"

Rails.application.configure do

  config.enable_reloading = false

  config.hosts << "api.movementparties.com"

  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false

  # config.active_storage.service = :local
  config.active_storage.service = :amazon


  config.force_ssl = true

  config.logger = ActiveSupport::TaggedLogging.new(
    ActiveSupport::Logger.new("log/production_requests.log", 10, 50.megabytes)
  )

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]


  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")


  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

end
