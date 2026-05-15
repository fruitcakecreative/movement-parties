class Api::UserEventsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_event, only: [:create, :destroy]

  # GET /api/users/:user_id/user_events — only for self or accepted friends
  def for_user
    return render json: {}, status: :unauthorized unless current_user

    target_id = Integer(params[:user_id], exception: false)
    return render json: { error: "Not found" }, status: :not_found unless target_id

    target = User.find_by(id: target_id)
    return render json: { error: "Not found" }, status: :not_found unless target

    unless target.id == current_user.id || accepted_friendship?(current_user, target)
      return render json: { error: "Not found" }, status: :not_found
    end

    events = target.user_events.includes(event: [:venue, :genres, :artists])
    grouped = events.group_by(&:status).transform_values do |user_events|
      user_events.map do |ue|
        ue.event.as_json(
          include: {
            venue: {},
            genres: {},
            artists: {}
          },
          methods: [:formatted_start_time, :formatted_end_time]
        ).merge(status: ue.status)
      end
    end

    render json: grouped, status: :ok
  end

  def index
    return render json: {}, status: :unauthorized unless current_user
    events = current_user.user_events.includes(:event)
    grouped = events.group_by(&:status).transform_values do |user_events|
      user_events.map do |ue|
        ue.event.as_json(
          include: {
            venue: {},
            genres: {},
            artists: {}
          },
          methods: [:formatted_start_time, :formatted_end_time]
        ).merge(status: ue.status)
      end
    end

    render json: grouped, status: :ok
  end


  def create
    Rails.logger.debug "Create UserEvent Params: #{params.inspect}"
    status = params.dig(:user_event, :status)
    status = status.downcase
    unless %w[attending interested].include?(status)
      return render json: { error: 'Invalid status', received: status }, status: :unprocessable_entity
    end

    user_event = current_user.user_events.find_or_initialize_by(event: @event)
    user_event.assign_attributes(status: status.to_sym)


    if user_event.save
      render json: {
        message: "#{status} updated",
        user_event: user_event.attributes.merge("status_text" => user_event.status)
      }, status: :ok
    else
      Rails.logger.error user_event.errors.full_messages
      render json: { errors: user_event.errors.full_messages }, status: :unprocessable_entity
    end

  end

  def destroy
    user_event = current_user.user_events.find_by(event: @event)
    if user_event&.destroy
      render json: { message: 'Event removed from profile' }, status: :ok
    else
      render json: { error: 'Event not found' }, status: :not_found
    end
  end

  def friend_attendees
    unless current_user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    eid = Integer(params[:event_id], exception: false)
    return render json: { error: "Not found" }, status: :not_found unless eid

    ordered = ordered_friend_users_for_event(eid, :attending)
    render json: ordered.map { |u| friend_attendee_json(u) }
  end

  # GET /api/user_events/:event_id/friend_rsvps — accepted friends attending + interested (detail UI)
  def friend_rsvps
    unless current_user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    eid = Integer(params[:event_id], exception: false)
    return render json: { error: "Not found" }, status: :not_found unless eid

    attending = ordered_friend_users_for_event(eid, :attending).map { |u| friend_attendee_json(u) }
    interested = ordered_friend_users_for_event(eid, :interested).map { |u| friend_attendee_json(u) }

    render json: { attending: attending, interested: interested }, status: :ok
  end

  # GET /api/user_events/:event_id/friend_counts — accepted friends with this event saved (by status)
  def friend_counts
    unless current_user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    event_id = params[:event_id].presence
    return render json: { error: "Not found" }, status: :not_found unless event_id

    friend_ids = current_user.friends.pluck(:id)
    return render json: { friends_attending: 0, friends_interested: 0 } if friend_ids.empty?

    scope = UserEvent.where(user_id: friend_ids, event_id: event_id)
    attending = scope.where(status: :attending).count
    interested = scope.where(status: :interested).count

    render json: {
      friends_attending: attending,
      friends_interested: interested,
    }, status: :ok
  end

  # POST /api/user_events/friend_counts_batch body: { event_ids: [1, 2, 3] }
  def friend_counts_batch
    unless current_user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    raw_ids = params[:event_ids]
    ids = Array(raw_ids).map { |x| Integer(x, exception: false) }.compact.uniq
    ids = ids.first(500)

    result = ids.each_with_object({}) do |id, h|
      h[id.to_s] = { friends_attending: 0, friends_interested: 0 }
    end

    friend_ids = current_user.friends.pluck(:id)
    if friend_ids.empty? || ids.empty?
      return render json: { counts: result }, status: :ok
    end

    UserEvent.where(user_id: friend_ids, event_id: ids).find_each do |ue|
      key = ue.event_id.to_s
      next unless result.key?(key)

      if ue.attending?
        result[key][:friends_attending] += 1
      elsif ue.interested?
        result[key][:friends_interested] += 1
      end
    end

    render json: { counts: result }, status: :ok
  end


  private

  # Preserves UserEvent row order within status; loads avatars in one query.
  def ordered_friend_users_for_event(event_id, status)
    friend_ids = current_user.friends.pluck(:id)
    return [] if friend_ids.empty?

    user_ids = UserEvent
      .where(user_id: friend_ids, event_id: event_id, status: status)
      .distinct
      .pluck(:user_id)

    users = User.with_attached_avatar.where(id: user_ids).index_by(&:id)
    user_ids.filter_map { |id| users[id] }
  end

  def friend_attendee_json(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil,
      picture: user.picture.presence,
    }
  end

  def accepted_friendship?(a, b)
    Friendship.exists?(user: a, friend: b, status: "accepted") ||
      Friendship.exists?(user: b, friend: a, status: "accepted")
  end

  def set_event
    event_id = params[:event_id].presence || params.dig(:user_event, :event_id)
    raise ActiveRecord::RecordNotFound if event_id.blank?

    @event = Event.find(event_id)
  end
end
