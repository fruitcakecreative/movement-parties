include ActionController::Flash
include ActionController::Cookies
include ActionController::MimeResponds

class Api::Users::SessionsController < Devise::SessionsController
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception
  # JSON API + SPA (cookies via CORS); same as ApplicationController for /api
  skip_before_action :verify_authenticity_token, if: -> { request.path.start_with?("/api") }
  # Devise default runs verify_signed_out_user + respond_to_on_destroy (HTML/redirect oriented);
  # it can mis-handle JSON and stall or double-render. We handle all cases in #destroy.
  skip_before_action :verify_signed_out_user, only: :destroy
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource, remember: true)

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
