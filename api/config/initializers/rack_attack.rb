require "rack/attack"
class Rack::Attack

  blocklist('block user agents') do |req|
    next false if Rails.env.development?
    req.user_agent =~ /curl|httpie|Postman/i
  end

  throttle('req/ip', limit: 60, period: 60.seconds) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  throttle('events/ip', limit: 10, period: 1.minute) do |req|
    req.ip if req.path == "/api/events"
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
