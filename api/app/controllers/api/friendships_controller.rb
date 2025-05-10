include Devise::Controllers::Helpers

class Api::FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.friends.map { |f|
      {
        id: f.id,
        username: f.username,
        avatar_url: f.avatar.attached? ? url_for(f.avatar) : nil
      }
    }
  end

  def pending
    requests = current_user.incoming_friend_requests.includes(:user)
    render json: requests.map { |f| { id: f.user.id, username: f.user.username } }
  end

  def create
    friend = User.find_by(username: params[:username])
    return render json: { error: "User not found" }, status: :not_found unless friend

    if Friendship.exists?(user: current_user, friend: friend)
      return render json: { message: "Already sent/requested" }
    end

    Friendship.create(user: current_user, friend: friend, status: "pending")
    render json: { message: "Request sent to #{friend.username}" }
  end

  def accept
    requester = User.find_by(id: params[:user_id])
    friendship = Friendship.find_by(user: requester, friend: current_user, status: "pending")
    return render json: { error: "Request not found" }, status: :not_found unless friendship

    Friendship.transaction do
      friendship.update!(status: "accepted")
      Friendship.create!(user: current_user, friend: requester, status: "accepted")
    end

    render json: { message: "Friend request accepted" }
  end
end
