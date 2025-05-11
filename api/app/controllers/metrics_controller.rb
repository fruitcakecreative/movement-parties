class MetricsController < ActionController::Base
  def index
    auth = request.headers["Authorization"].to_s
    token = ENV["METRICS_TOKEN"]

    unless token
      Rails.logger.error "Missing METRICS_TOKEN env var"
      render plain: "Missing token", status: :internal_server_error
      return
    end

    unless auth == "Bearer #{token}"
      Rails.logger.warn "Unauthorized access to /metrics — got: #{auth.inspect}"
      head :unauthorized
      return
    end

    begin
      metrics = Yabeda::Prometheus::Exporter.export
      Rails.logger.info "Successfully served /metrics"
      render plain: metrics
    rescue => e
      Rails.logger.error "Metrics export failed: #{e.class} - #{e.message}"
      render plain: "Error generating metrics: #{e.message}", status: :internal_server_error
    end
  end
end
