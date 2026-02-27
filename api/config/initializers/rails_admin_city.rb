# config/initializers/rails_admin_city.rb
Rails.application.config.to_prepare do
  next unless defined?(RailsAdmin::MainController)

  RailsAdmin::MainController.class_eval do
    before_action :set_rails_admin_city_key

    private

    def set_rails_admin_city_key
      key = params[:scope].presence || session[:rails_admin_city_key].presence || "movement"
      session[:rails_admin_city_key] = key
      Current.city_key = key
    end
  end
end
