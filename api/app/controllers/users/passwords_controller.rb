# frozen_string_literal: true

# JSON API for SPA: POST /api/password (request email), PUT /api/password (new password + token).
class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # Same response whether the email exists (avoid account enumeration).
  def create
    email = resource_params[:email].to_s.strip.downcase
    user = resource_class.find_for_authentication(email: email) if email.present?
    if user.present?
      begin
        user.send_reset_password_instructions
      rescue StandardError => e
        log_password_mail_failure("create/send_reset_password_instructions", user.id, e)
      end
    end

    render json: {
      message: "If that email is registered, you'll receive password reset instructions shortly."
    }, status: :ok
  rescue ActionController::ParameterMissing
    render json: { errors: ["Email is required."] }, status: :unprocessable_entity
  rescue StandardError => e
    # Anything else (DB, Warden, etc.): never 500 this endpoint — same body as success.
    log_password_mail_failure("create", nil, e)
    render json: {
      message: "If that email is registered, you'll receive password reset instructions shortly."
    }, status: :ok
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      ensure_authentication_token_for_spa!(resource)
      if Devise.sign_in_after_reset_password
        begin
          sign_in(resource_name, resource, remember: true)
        rescue StandardError => e
          log_password_mail_failure("update/sign_in", resource.id, e)
        end
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
  rescue StandardError => e
    log_password_mail_failure("update", resource&.id, e)
    render json: {
      errors: ["Something went wrong resetting your password. Request a new link and try again."]
    }, status: :unprocessable_entity
  end

  protected

  def respond_with(_resource, _opts = {})
    # Silence Devise HTML / redirect fallbacks; actions render JSON explicitly.
  end

  private

  def ensure_authentication_token_for_spa!(user)
    return if user.authentication_token.present?

    user.update_columns(authentication_token: SecureRandom.hex(20), updated_at: Time.current)
    user.reload
  end

  def log_password_mail_failure(context, user_id, error)
    Rails.logger.error(
      "[Users::PasswordsController##{context}] user_id=#{user_id} #{error.class}: #{error.message}\n" \
      "#{Array(error.backtrace).first(12).join("\n")}"
    )
    return unless defined?(Rails.error)

    Rails.error.report(error, handled: true)
  rescue StandardError => report_error
    Rails.logger.error(
      "[Users::PasswordsController##{context}] error reporting failed #{report_error.class}: #{report_error.message}"
    )
  end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end
