class MetricsAuthentication
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    auth_header = request.get_header("HTTP_AUTHORIZATION")
    token = ENV["METRICS_TOKEN"]

    if auth_header == "Bearer #{token}"
      @app.call(env)
    else
      [401, { "Content-Type" => "text/plain" }, ["Unauthorized"]]
    end
  end
end
