require "rack/attack"
class Rack::Attack

  blocklist('block user agents') do |req|
    next false if Rails.env.development?
    req.user_agent =~ /curl|httpie|Postman/i
  end

  # Dev SPA + HMR can burst /api calls. Do not add a second stricter throttle on /api/events —
  # 10/min there was locking out normal browsing (reloads / filters) with 429.
  throttle('req/ip', limit: (Rails.env.development? ? 600 : 300), period: 60.seconds) do |req|
    if req.path == "/api/user" || req.path == "/api/login" || req.path == "/api/logout"
      false
    elsif req.path.start_with?("/api/")
      req.ip
    end
  end

  ActiveSupport::Notifications.subscribe("rack.attack") do |_, _, _, _, payload|
    req = payload[:request]
    Rails.logger.info "Rack::Attack event: #{req.ip} => #{req.path}"
  end


  self.throttled_responder = lambda do |req|
    Rails.logger.warn("Rate limit triggered: #{req.ip} - UA: #{req.user_agent}")

    unless Rails.env.development?
      Honeybadger.notify("Rate limit hit", context: {
        ip: req.ip,
        user_agent: req.user_agent,
        path: req.path
      })
    end

    [429, { 'Content-Type' => 'application/json' }, [{ error: 'Too many requests' }.to_json]]
  end
end
