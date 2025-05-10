  Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000',
            'https://movementparties.netlify.app',
            'http://new.movementparties.com',
            'https://new.movementparties.com',
            'https://new.movementparties.com'
            'https://www.movementparties.com',
            'https://movementparties.com',
            'https://0668-2601-406-5083-f5d0-10d5-68ad-f764-1f2e.ngrok-free.app',
            /https:\/\/.*--steady-sunshine-e9c556\.netlify\.app/

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options],
      credentials: true
  end
end
