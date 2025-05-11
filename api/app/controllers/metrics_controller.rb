class MetricsController < ActionController::Base
  http_basic_authenticate_with name: ENV["METRICS_USERNAME"], password: ENV["METRICS_PASSWORD"]

  def index
    render plain: Yabeda::Prometheus::Exporter.export
  end
end
