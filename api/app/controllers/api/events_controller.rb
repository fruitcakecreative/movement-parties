class Api::EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :set_current_city_key

  def index
    request.env["action_dispatch.request_start_time"] = Time.now

    city = current_city_key
    include_past = city == "mmw" && request.headers["X-Include-Past-Events"].to_s == "1"
    cache_key = "events-v8:#{city}:#{include_past ? 'all' : 'upcoming'}"

    events = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      scope = Event.where(city_key: city)
                   .includes(:genres, :artists, venue: [:parent_venue, :child_venues])
      scope = scope.not_past unless include_past
      scope.order(start_time: :asc, end_time: :asc)
           .as_json(
             include: {
               genres: { only: [:id, :name, :short_name, :hex_color, :font_color] },
               artists: { only: [:id, :name, :pronouns] },
               venue: {
                 methods: [:logo_url, :venue_ids_for_events, :display_venue_for_json],
                 only: [
                   :id, :name, :age, :image_filename, :address, :location,
                   :venue_url, :description, :distance, :serves_alcohol,
                   :venue_type, :additional_images, :bg_color, :font_color, :subheading, :source,
                   :parent_venue_id
                 ]
               }
             },
             methods: [:formatted_start_time, :formatted_end_time, :top_artists]
           )
    end

    past_count = Event.where(city_key: city).past_for_list.count

    Rails.logger.info("[RAILS] Completed Api::EventsController#index city=#{city} events=#{events.length} in #{(Time.now - request.env["action_dispatch.request_start_time"]) * 1000}ms")
    render json: {
      events: events,
      meta: {
        last_updated: Event.where(city_key: city).maximum(:updated_at),
        total_count: events.size,
        past_count: past_count
      }
    }
  end

  def show
    render json: @event.as_json(include: [:venue, :artists, :genres])
  end

  def create
    event = Event.new(event_params)
    event.city_key = current_city_key

    if event.save
      Event.clear_public_index_cache!(event.city_key)
      render json: event, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      Event.clear_public_index_cache!(@event.city_key)
      render json: @event
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    city = @event.city_key
    @event.destroy
      Event.clear_public_index_cache!(city)
    head :no_content
  end

  private

  def current_city_key
    (params[:city].presence || request.headers["X-City-Key"].presence || "movement").downcase
  end

  def set_event
    @event = Event.find_by!(id: params[:id], city_key: current_city_key)
  end

  def event_params
    params.require(:event).permit(
      :title, :date, :start_time, :end_time, :venue_id, :description, :event_url, :source,
      genre_ids: []
    )
  end

  def set_current_city_key
    Current.city_key = current_city_key if defined?(Current)
  end
end
