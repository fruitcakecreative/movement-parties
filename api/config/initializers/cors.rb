if Rails.env.development?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:3000', 'https://localhost:3000', 'http://localhost:3002', 'https://localhost:3002', 'http://localhost:3003', 'https://localhost:3003'
      resource '*', headers: :any, methods: :any, credentials: true
    end
  end
end

if Rails.env.staging?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'https://staging.movementparties.com'
      resource '*', headers: :any, methods: :any, credentials: true
    end
  end
end

if Rails.env.production?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'https://movementparties.com', 'https://new.movementparties.com', "https://mmwparties.com", "https://mmw-parties-client.netlify.app"
      resource '*', headers: :any, methods: :any, credentials: true
    end
  end
end
