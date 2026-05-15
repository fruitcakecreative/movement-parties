class Api::FriendshipsController < ApplicationController
  include Devise::Controllers::Helpers

  before_action :authenticate_user!

  def index
    friends = current_user.friends.includes(avatar_attachment: :blob)
    render json: friends.map { |f| serialize_friend_user(f) }
  end

  def pending
    requests = current_user.incoming_friend_requests.includes(user: { avatar_attachment: :blob })
    render json: requests.map { |f| serialize_friend_user(f.user) }
  end

  def search
    q = params[:q].to_s.strip
    return render json: [] if q.blank?

    users = User
      .with_attached_avatar
      .where.not(id: current_user.id)
      .where(
        "username ILIKE :q OR email ILIKE :q OR name ILIKE :q",
        q: "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      )
      .limit(20)
      .to_a

    user_ids = users.map(&:id)
    status_by_id = friendship_status_with_viewer(user_ids)

    render json: users.map { |u|
      serialize_friend_user(u).merge(friendship_status: status_by_id[u.id] || "none")
    }
  end

  def create
    friend =
      if params[:user_id].present?
        User.find_by(id: params[:user_id])
      elsif params[:username].present?
        User.find_by(username: params[:username])
      else
        nil
      end
    return render json: { error: "User not found" }, status: :not_found unless friend
    return render json: { error: "You cannot friend yourself" }, status: :unprocessable_entity if friend.id == current_user.id

    if Friendship.exists?(user: current_user, friend: friend)
      return render json: { message: "Already sent/requested" }
    end

    Friendship.create(user: current_user, friend: friend, status: "pending")
    label = friend.name.presence || friend.email
    render json: { message: "Request sent to #{label}" }
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

  def reject
    requester = User.find_by(id: params[:user_id])
    friendship = Friendship.find_by(user: requester, friend: current_user, status: "pending")
    return render json: { error: "Request not found" }, status: :not_found unless friendship

    friendship.destroy
    render json: { message: "Friend request rejected" }
  end

  # Accepted friends of `user_id`. Viewer must be that user or an accepted friend.
  def friends_of_user
    uid = Integer(params[:user_id], exception: false)
    return render json: { error: "Not found" }, status: :not_found unless uid

    other = User.find_by(id: uid)
    return render json: { error: "Not found" }, status: :not_found unless other

    unless other.id == current_user.id || accepted_friendship?(current_user, other)
      return render json: { error: "Not found" }, status: :not_found
    end

    friends = other.friends.includes(avatar_attachment: :blob).to_a.reject { |u| u.id == current_user.id }
    user_ids = friends.map(&:id)
    status_by_id = friendship_status_with_viewer(user_ids)

    render json: friends.map { |u|
      serialize_friend_of_user_row(u, status_by_id[u.id] || "none")
    }
  end

  def destroy
    friend =
      if params[:user_id].present?
        User.find_by(id: params[:user_id])
      elsif params[:username].present?
        User.find_by(username: params[:username])
      end
    return render json: { error: "User not found" }, status: :not_found unless friend

    Friendship.where(user: current_user, friend: friend).or(
      Friendship.where(user: friend, friend: current_user)
    ).destroy_all

    render json: { message: "Friendship removed" }
  end

  private

  def accepted_friendship?(a, b)
    Friendship.exists?(user: a, friend: b, status: "accepted") ||
      Friendship.exists?(user: b, friend: a, status: "accepted")
  end

  def serialize_friend_of_user_row(u, friendship_status)
    {
      id: u.id,
      name: u.name,
      username: u.username,
      email: u.email,
      avatar_url: u.avatar.attached? ? url_for(u.avatar) : nil,
      picture: u.picture.presence,
      friendship_status: friendship_status
    }
  end

  def serialize_friend_user(u)
    {
      id: u.id,
      username: u.username,
      name: u.name,
      email: u.email,
      avatar_url: u.avatar.attached? ? url_for(u.avatar) : nil,
      picture: u.picture.presence
    }
  end

  def friendship_status_with_viewer(user_ids)
    return {} if user_ids.blank?

    outgoing = Friendship
      .where(user_id: current_user.id, friend_id: user_ids, status: "pending")
      .pluck(:friend_id)
      .to_set
    incoming = Friendship
      .where(friend_id: current_user.id, user_id: user_ids, status: "pending")
      .pluck(:user_id)
      .to_set
    friend_ids = Friendship
      .where(user_id: current_user.id, friend_id: user_ids, status: "accepted")
      .pluck(:friend_id)
      .to_set
    friend_ids.merge(
      Friendship.where(friend_id: current_user.id, user_id: user_ids, status: "accepted").pluck(:user_id)
    )

    user_ids.index_with do |id|
      if friend_ids.include?(id)
        "friend"
      elsif outgoing.include?(id)
        "outgoing_pending"
      elsif incoming.include?(id)
        "incoming_pending"
      else
        "none"
      end
    end
  end
end
