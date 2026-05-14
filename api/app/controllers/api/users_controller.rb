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
      sign_in(:user, @user, remember: true)
      warden.set_user(@user, scope: :user, store: true)
      Rails.logger.debug "SIGNED IN USER: #{current_user&.email}"
      Rails.logger.debug "SESSION AFTER SIGN IN: #{session.to_hash.inspect}"
      token = @user.authentication_token
      render json: {
        message: 'User created/updated from Facebook',
        user: {
          id: @user.id,
          name: @user.name,
          email: @user.email,
          username: @user.username,
          picture: @user.picture,
          token: token,
          authentication_token: token
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

  # GET /api/users/:id — self or accepted friend only
  def show_by_id
    id = Integer(params[:id], exception: false)
    return render json: { error: "Not found" }, status: :not_found unless id

    other = User.with_attached_avatar.find_by(id: id)
    return render json: { error: "Not found" }, status: :not_found unless other

    if other.id == current_user.id
      return render json: public_user_json(other, is_self: true, is_friend: false)
    end

    unless accepted_friendship?(current_user, other)
      return render json: { error: "Not found" }, status: :not_found
    end

    render json: public_user_json(other, is_self: false, is_friend: true)
  end

  private

  def public_user_json(user, is_self:, is_friend:)
    {
      id: user.id,
      name: user.name,
      username: user.username,
      email: is_self ? user.email : nil,
      picture: user.picture.presence,
      avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil,
      is_self: is_self,
      is_friend: is_friend
    }
  end

  def accepted_friendship?(a, b)
    Friendship.exists?(user: a, friend: b, status: "accepted") ||
      Friendship.exists?(user: b, friend: a, status: "accepted")
  end
end
