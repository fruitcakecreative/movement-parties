class Api::UserEventsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_event, only: [:create, :destroy]

  def index
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
    puts "Cookies: #{request.cookies.to_h}"
     puts "Session: #{session.to_hash}"
     puts "Current user: #{current_user&.id || 'none'}"
    unless current_user
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    event_id = params[:event_id]
    friends = current_user.friends
    attendees = friends.joins(:user_events)
                       .where(user_events: { event_id:, status: "attending" })
    render json: attendees.select(:id, :username)
  end


  private

  def set_event
    @event = Event.find(params.dig(:user_event, :event_id))
  end
end
