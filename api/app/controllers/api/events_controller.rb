class Api::EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy, :rsvp_totals]
  before_action :set_current_city_key

  def index
    city = current_city_key
    include_past = city == "mmw" && request.headers["X-Include-Past-Events"].to_s == "1"
    cache_key = "events-v9:#{city}:#{include_past ? 'all' : 'upcoming'}"

    result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      scope = Event
        .where(city_key: city)
        .includes(
          :genres,
          :artists,
          logo_attachment: :blob,                         # event poster_url
          venue: [
            :parent_venue,
            { child_venues: { logo_attachment: :blob } }, # child venue logo_url
            logo_attachment: :blob                        # venue logo_url
          ]
        )

      scope = scope.not_past unless include_past
      events = scope.order(start_time: :asc, end_time: :asc).to_a

      {
        events: serialize_events(events),
        last_updated: events.map(&:updated_at).max,
        past_count: Event.where(city_key: city).past_for_list.count
      }
    end

    render json: {
      events: result[:events],
      meta: {
        last_updated: result[:last_updated],
        total_count: result[:events].size,
        past_count: result[:past_count]
      }
    }
  end

  def show
    render json: @event.as_json(
      include: [:venue, :artists, :genres],
      methods: [:formatted_start_time, :formatted_end_time, :top_artists, :poster_url]
    )
  end

  def rsvp_totals
    interested = UserEvent.where(event_id: @event.id, status: :interested).count
    attending  = UserEvent.where(event_id: @event.id, status: :attending).count
    render json: {
      app_interested_count: interested,
      app_attending_count:  attending
    }, status: :ok
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
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    city = @event.city_key
    @event.destroy
    Event.clear_public_index_cache!(city)
    head :no_content
  end

  private

  def serialize_events(events)
    events.map do |event|
      venue = event.venue

      event_json = {
        id:                   event.id,
        title:                event.title,
        created_at:           event.created_at,
        updated_at:           event.updated_at,
        date:                 event.date,
        start_time:           event.start_time,
        end_time:             event.end_time,
        description:          event.description,
        event_url:            event.event_url,
        ticket_url:           event.try(:ticket_url),
        ra_url:               event.try(:ra_url),
        dice_url:             event.try(:dice_url),
        source:               event.source,
        city_key:             event.city_key,
        bg_color:             event.try(:bg_color),
        font_color:           event.try(:font_color),
        formatted_start_time: event.formatted_start_time,
        formatted_end_time:   event.formatted_end_time,
        poster_url:           poster_url_for(event),
        top_artists:          top_artists_for(event),
        genres: event.genres.map { |g|
          {
            id:          g.id,
            name:        g.name,
            short_name:  g.short_name,
            hex_color:   g.hex_color,
            font_color:  g.font_color
          }
        },
        artists: event.artists.map { |a|
          { id: a.id, name: a.name, pronouns: a.pronouns }
        },
        venue: venue ? serialize_venue(venue) : nil
      }

      event_json
    end
  end

  def serialize_venue(venue)
    {
      id:                    venue.id,
      name:                  venue.name,
      age:                   venue.age,
      image_filename:        venue.image_filename,
      address:               venue.address,
      location:              venue.location,
      venue_url:             venue.venue_url,
      description:           venue.description,
      distance:              venue.distance,
      serves_alcohol:        venue.serves_alcohol,
      venue_type:            venue.venue_type,
      additional_images:     venue.additional_images,
      bg_color:              venue.bg_color,
      font_color:            venue.font_color,
      subheading:            venue.subheading,
      parent_venue_id:       venue.parent_venue_id,
      logo_url:              logo_url_for(venue),
      venue_ids_for_events:  venue_ids_for_events_for(venue),
      display_venue_for_json: display_venue_for_json_for(venue)
    }
  end

  # Avoids calling logo.attached? per record — attachment already eager loaded
  def logo_url_for(venue)
    return nil unless venue.logo_attachment

    Rails.application.routes.url_helpers.rails_blob_url(
      venue.logo, disposition: :inline, only_path: false
    )
  end

  def poster_url_for(event)
    if event.logo_attachment
      Rails.application.routes.url_helpers.rails_blob_url(
        event.logo, disposition: :inline, only_path: false
      )
    else
      event.event_image_url
    end
  end

  def top_artists_for(event)
    event.artists
         .sort_by { |a| -(a.ra_followers || 0) }
         .first(100)
         .map { |a| { id: a.id, name: a.name, ra_followers: a.ra_followers, pronouns: a.pronouns } }
  end

  # All in memory — no extra queries since parent_venue + child_venues already loaded
  def venue_ids_for_events_for(venue)
    if venue.parent_venue_id.present?
      parent = venue.parent_venue
      [parent.id] + parent.child_venues.map(&:id)
    elsif venue.child_venues.any?
      [venue.id] + venue.child_venues.map(&:id)
    else
      [venue.id]
    end
  end

  def display_venue_for_json_for(venue)
    return nil unless venue.parent_venue_id.present? || venue.child_venues.any?

    dv = venue.parent_venue || venue
    {
      id:                   dv.id,
      name:                 dv.name,
      description:          dv.description,
      subheading:           dv.subheading,
      address:              dv.address,
      location:             dv.location,
      age:                  dv.age,
      venue_url:            dv.venue_url,
      venue_type:           dv.venue_type,
      logo_url:             logo_url_for(dv),
      bg_color:             dv.bg_color,
      font_color:           dv.font_color,
      parent_section_label: dv.try(:parent_section_label),
      child_venues:         dv.child_venues.map { |c|
        {
          id:        c.id,
          name:      c.name,
          subheading: c.subheading,
          logo_url:  logo_url_for(c)
        }
      }
    }
  end

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