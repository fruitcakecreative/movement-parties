Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.dsn = ENV['SENTRY_DSN']
  # Avoid local 403 noise when SENTRY_DSN is missing/wrong (e.g. "ProjectId" rejection on flush).
  # Set SENTRY_ENABLE_DEVELOPMENT=1 to report from development.
  config.enabled_environments = if ENV['SENTRY_ENABLE_DEVELOPMENT'] == '1'
    %w[development production staging]
  else
    %w[production staging]
  end
  config.traces_sample_rate = 1.0
  config.send_default_pii = true
end
