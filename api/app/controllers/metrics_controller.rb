class MetricsController < ActionController::Base
  def index
    if request.headers["Authorization"] != "Bearer #{ENV['METRICS_TOKEN']}"
      head :unauthorized and return
    end

    render plain: Yabeda::Prometheus::Exporter.export(request.env)
  end
end
