class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env["omniauth.auth"]
    @user = User.from_facebook(auth)

    if @user.persisted?
      sign_in(@user)
      Rails.logger.info ">>> LOGIN: session: #{session.to_hash}"
      Rails.logger.info ">>> LOGIN: cookies: #{cookies.to_hash}"
      render json: {
        status: "success",
        user: @user.slice(:id, :name, :email, :username, :picture).merge(token: @user.authentication_token)
      }
    else
      render json: { error: "Could not authenticate via Facebook" }, status: :unauthorized
    end
  end

  def failure
    render json: { error: "Facebook authentication failed" }, status: :unauthorized
  end
end
