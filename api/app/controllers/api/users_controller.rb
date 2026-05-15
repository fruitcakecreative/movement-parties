class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_from_facebook]
  before_action :authenticate_user!, except: [:create_from_facebook] # Skip for Facebook login creation

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
      @user.assign_attributes(name: user_data[:name], picture: user_data[:picture])
      @user.save(validate: false) if @user.authentication_token.blank?
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
        message: "User created/updated from Facebook",
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
      render json: { error: "Failed to save user data" }, status: :unprocessable_entity
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

  # Same-origin avatar bytes for schedule share canvas (avoids S3/OAuth CORS).
  def schedule_share_avatar
    if current_user.avatar.attached?
      blob = current_user.avatar.blob
      return send_data(
        current_user.avatar.download,
        type: blob.content_type.presence || "image/jpeg",
        disposition: "inline"
      )
    end

    remote = safe_remote_avatar_uri(current_user.picture)
    unless remote
      return head :not_found
    end

    response = Net::HTTP.start(
      remote.host,
      remote.port,
      use_ssl: remote.scheme == "https",
      open_timeout: 5,
      read_timeout: 10
    ) do |http|
      http.request(Net::HTTP::Get.new(remote))
    end

    unless response.is_a?(Net::HTTPSuccess)
      return head :not_found
    end

    content_type = response.content_type.presence || "image/jpeg"
    send_data response.body, type: content_type, disposition: "inline"
  rescue StandardError => e
    Rails.logger.warn("schedule_share_avatar failed: #{e.class}: #{e.message}")
    head :not_found
  end

  def show
    render json: current_user_json
  end

  def update
    user_params = params.require(:user)
    permitted = user_params.permit(:name, :email)
    extra_permitted = user_params.permit(profile_extra: ProfileExtraInfo::PROFILE_EXTRA_KEYS)
    has_extra = user_params.key?(:profile_extra) || extra_permitted.key?(:profile_extra)

    ok = true
    if permitted.present?
      ok = current_user.update(permitted)
    end
    if ok && has_extra
      current_user.assign_profile_extra!(extra_permitted[:profile_extra] || {})
      ok = current_user.save(validate: false) if ok
    end

    if ok
      render json: current_user_json
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Another member's profile (must be friends, or your own id for a consistent client shape).
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

  REMOTE_AVATAR_HOST_SUFFIXES = %w[
    googleusercontent.com
    fbcdn.net
    fbsbx.com
    facebook.com
  ].freeze

  def safe_remote_avatar_uri(url)
    uri = URI.parse(url.to_s.strip)
    return nil unless uri.is_a?(URI::HTTP) && uri.host.present?

    host = uri.host.downcase
    return nil if host == "localhost" || host.end_with?(".local")
    return nil if host.match?(/\A(10\.|127\.|169\.254\.|192\.168\.|172\.(1[6-9]|2\d|3[01])\.)/)

    allowed = REMOTE_AVATAR_HOST_SUFFIXES.any? do |suffix|
      host == suffix || host.end_with?(".#{suffix}")
    end
    return nil unless allowed

    uri
  rescue URI::InvalidURIError
    nil
  end

  def current_user_json
    if current_user.authentication_token.blank?
      current_user.save(validate: false)
    end
    {
      id: current_user.id,
      name: current_user.name,
      email: current_user.email,
      authentication_token: current_user.authentication_token,
      avatar_url: current_user.avatar.attached? ? url_for(current_user.avatar) : current_user.picture,
      profile_extra: current_user.profile_extra_hash
    }
  end

  def accepted_friendship?(a, b)
    Friendship.exists?(user: a, friend: b, status: "accepted") ||
      Friendship.exists?(user: b, friend: a, status: "accepted")
  end

  def public_user_json(user, is_self:, is_friend:)
    {
      id: user.id,
      name: user.name,
      username: user.username,
      email: is_self ? user.email : nil,
      picture: user.picture.presence,
      avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil,
      is_self: is_self,
      is_friend: is_friend,
      profile_extra: user.profile_extra_hash
    }
  end
end
