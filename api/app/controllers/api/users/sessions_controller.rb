include ActionController::Flash
include ActionController::Cookies
include ActionController::MimeResponds

class Api::Users::SessionsController < Devise::SessionsController
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: -> { Rails.env.development? }
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    render json: {
      user: {
        id: resource.id,
        email: resource.email,
        username: resource.username,
        # avatar_url: resource.avatar_url
      }
    }
  end

  def destroy
    sign_out(resource_name)
    render json: { message: "Logged out" }, status: :ok
  end


  private

  def custom_respond_with(resource)
    render json: { user: { id: resource.id, email: resource.email }}
  end

  def respond_to_on_destroy
    render json: { message: current_user ? 'Logged out.' : 'Already logged out.' }, status: (current_user ? :ok : :unauthorized)
  end



end
