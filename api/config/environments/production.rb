require "active_support/core_ext/integer/time"

Rails.application.configure do

  config.enable_reloading = false

  config.hosts << "api.movementparties.com"
  config.hosts << "movement-parties-3hop.onrender.com"

  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false

  # config.active_storage.service = :local
  config.active_storage.service = :amazon


  config.force_ssl = true

  logger = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = proc do |severity, datetime, _progname, msg|
    "[RAILS] #{datetime.utc.iso8601} #{severity}: #{msg}\n"
  end

  config.logger = ActiveSupport::TaggedLogging.new(logger)

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
