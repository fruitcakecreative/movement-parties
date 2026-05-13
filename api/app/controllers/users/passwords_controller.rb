# frozen_string_literal: true

# JSON API for SPA: POST /api/users/password (request email), PUT /api/users/password (new password + token).
class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # Same response whether the email exists (avoid account enumeration).
  def create
    email = resource_params[:email].to_s.strip.downcase
    user = resource_class.find_for_authentication(email: email) if email.present?
    user&.send_reset_password_instructions

    render json: {
      message: "If that email is registered, you'll receive password reset instructions shortly."
    }, status: :ok
  rescue ActionController::ParameterMissing
    render json: { errors: ["Email is required."] }, status: :unprocessable_entity
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      if Devise.sign_in_after_reset_password
        sign_in(resource_name, resource, remember: true)
      end
      render json: {
        message: "Your password has been changed.",
        user: resource.slice(:id, :email, :username, :authentication_token)
      }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    render json: { errors: ["Reset token and password are required."] }, status: :unprocessable_entity
  end

  protected

  def respond_with(_resource, _opts = {})
    # Silence Devise HTML / redirect fallbacks; actions render JSON explicitly.
  end

  private

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end
