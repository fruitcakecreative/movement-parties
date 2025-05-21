class Api::EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]

  def index
    request.env['action_dispatch.request_start_time'] = Time.now
    cache_key = "events-v1"

    events = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      Event.includes(:genres, :venue, :artists)
           .order(start_time: :asc, end_time: :asc)
           .as_json(
             include: {
               genres: {
                 only: [:id, :name, :short_name, :hex_color, :font_color]
               },
               venue: {
                 methods: [:logo_url],
                 only: [
                   :id, :name, :image_filename, :address, :location,
                   :venue_url, :description, :distance, :serves_alcohol,
                   :venue_type, :additional_images, :bg_color, :font_color, :subheading
                 ]
               }
             },
             methods: [:formatted_start_time, :formatted_end_time, :top_artists]
           )
    end
    Rails.logger.info("[RAILS] Completed Api::EventsController#index with #{events.length} events in #{(Time.now - request.env['action_dispatch.request_start_time']) * 1000}ms")
    render json: { events: events }
  end

  def formatted_start_time
    start_time&.iso8601
  end

  def formatted_end_time
    end_time&.iso8601
  end

  def show
    render json: @event.to_json(include: [:venue, :artists, :genres])
  end

  def create
    event = Event.new(event_params)
    if event.save
      render json: event, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :date, :start_time, :end_time, :venue_id, :description, :event_url, :source, genre_ids: [])
  end
end
