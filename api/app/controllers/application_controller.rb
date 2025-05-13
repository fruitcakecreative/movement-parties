class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Devise::Controllers::Helpers

  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token, if: -> {
    Rails.env.development? && request.format.json?
  }

  private
  
end
