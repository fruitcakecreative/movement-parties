# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Devise::Controllers::Helpers

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: -> { request.path.start_with?("/api") }

  # SPA is on another origin; session cookies are unreliable cross-origin.
  # Clients send Authorization: Bearer <authentication_token> (see login/signup JSON).
  prepend_before_action :authenticate_user_from_bearer_token

  private

  def authenticate_user_from_bearer_token
    return if user_signed_in?

    token = request.authorization&.sub(/\ABearer\s+/i, "")
    return if token.blank?

    user = User.find_by(authentication_token: token)
    sign_in(:user, user, store: false) if user
  end
end
