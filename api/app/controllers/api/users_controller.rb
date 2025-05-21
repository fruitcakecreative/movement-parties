class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_from_facebook]
  before_action :authenticate_user!, except: [:create_from_facebook]  # Skip for Facebook login creation

  # This method handles the data from Facebook login (when user is not logged in)
  def create_from_facebook
    user_data = params.require(:user).permit(:name, :email, :picture)
    Rails.logger.debug "User data received: #{user_data.inspect}"

    @user = User.find_or_initialize_by(email: user_data[:email])
    @user.name = user_data[:name]
    @user.picture = user_data[:picture]
    @user.password = Devise.friendly_token[0, 20]

    Rails.logger.debug "User after find_or_initialize_by: #{@user.inspect}"

    if @user.persisted?
      @user.update(name: user_data[:name], picture: user_data[:picture])
      Rails.logger.debug "User updated: #{@user.inspect}"
    end

     @user.username = @user.email if @user.username.blank?

    if @user.save
      sign_in(:user, @user)
      warden.set_user(@user, scope: :user, store: true)
      Rails.logger.debug "SIGNED IN USER: #{current_user&.email}"
      Rails.logger.debug "SESSION AFTER SIGN IN: #{session.to_hash.inspect}"
      render json: {
        message: 'User created/updated from Facebook',
        user: {
          id: @user.id,
          name: @user.name,
          email: @user.email,
          username: @user.username,
          picture: @user.picture,
          token: @user.authentication_token
        }
      }, status: :created
    else
      Rails.logger.debug "Errors: #{@user.errors.full_messages}"
      render json: { error: 'Failed to save user data' }, status: :unprocessable_entity
    end
  end

  def upload_avatar
    if params[:avatar].present?
      current_user.avatar.attach(params[:avatar])
      render json: { message: "Avatar uploaded", url: url_for(current_user.avatar) }
    else
      render json: { error: "No file uploaded" }, status: :unprocessable_entity
    end
  end


  def show
    render json: {
      id: current_user.id,
      name: current_user.name,
      email: current_user.email,
      username: current_user.username,
      avatar_url: current_user.avatar.attached? ? url_for(current_user.avatar) : current_user.picture
    }
  end
end
