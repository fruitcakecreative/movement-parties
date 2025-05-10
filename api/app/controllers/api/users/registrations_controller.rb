include ActionController::Flash
include ActionController::MimeResponds
include ActionController::Cookies

class Api::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.username = resource.email if resource.username.blank?
    resource.name = params[:user][:name] if resource.name.blank?
    resource.save
    if resource.persisted?
      sign_up(resource_name, resource)
      render json: { message: 'Signed up.', user: resource.slice(:id, :email) }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  protected

  def respond_with(resource, _opts = {})
    # do nothing, silence Devise fallback
  end
end
