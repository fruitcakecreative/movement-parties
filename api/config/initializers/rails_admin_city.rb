# config/initializers/rails_admin_city.rb
Rails.application.config.to_prepare do
  next unless defined?(RailsAdmin::MainController)

  RailsAdmin::MainController.class_eval do
    before_action :set_rails_admin_city_key

    private

    def set_rails_admin_city_key
      # Prefer URL scope; default Movement (do not inherit stale session "mmw" on every request).
      key = params[:scope].presence || "movement"
      session[:rails_admin_city_key] = key
      Current.city_key = key
    end
  end
end
