class MetricsController < ActionController::Base
  USERNAME = ENV["METRICS_USERNAME"] || "missing_user"
  PASSWORD = ENV["METRICS_PASSWORD"] || "missing_pass"

  http_basic_authenticate_with name: USERNAME, password: PASSWORD

  def index
    render plain: Yabeda::Prometheus::Exporter.export
  end
end
