if Rails.env.development?
  Rails.application.routes.default_url_options = {
    host: 'localhost',
    port: 3001,
    protocol: 'https'
  }
end
