class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Devise::Controllers::Helpers

  protect_from_forgery with: :exception
  before_action :set_current_city_key

end
