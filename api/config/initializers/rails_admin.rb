RailsAdmin.config do |config|
  config.asset_source = :sprockets

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Event' do
    list do
      items_per_page 50
      sort_by :start_time
    end

  edit do
    field :title
    field :manual_override_title, :boolean
    field :short_title
    field :even_shorter_title
    field :start_time
    field :end_time
    field :manual_override_times
    field :venue
    field :manual_override_location
    field :genres
    field :manual_override_genres
    field :artists do
      associated_collection_cache_all false
      associated_collection_scope do
        ->(scope) { scope.limit(100) }
      end
    end
    field :manual_artist_names, :text do
      help "Comma-separated list of artist names to manually add"
    end
    field :manual_override_artists, :boolean
    field :logo, :active_storage
    field :description
    field :bg_color do
      partial 'color_picker'
    end
    field :font_color do
      partial 'color_picker'
    end
    field :free_event
    field :food_available
    field :age, :enum do
      enum do
        ['All Ages', '18+', '21+']
      end
    end

    field :indoor_outdoor, :enum do
      enum do
        ['Indoor', 'Outdoor', 'Both']
      end
    end
    field :promoter
    field :notes
    field :event_url
    field :ticket_url
    field :ticket_price
    field :ticket_tier
    field :ticket_wave
    field :manual_override_ticket
    field :manual_override  # ✅ add this line
  end
end

  config.model 'Venue' do
    edit do
      field :name
      field :location
      field :image_filename
      field :logo, :active_storage
      field :venue_url
      field :address
      field :description
      field :distance
      field :additional_images
      field :serves_alcohol
      field :venue_type, :enum do
        enum do
          ['Warehouse', 'Club', 'Bar/Restaurant', 'Outdoor Event Space', 'Theatre', 'Music Venue']
        end
      end
      field :subheading
      field :hex_color do
        partial 'color_picker'
      end
      field :font_color do
        partial 'color_picker'
      end
    end
  end

  config.model 'Genre' do
    edit do
      field :name
      field :short_name
      field :hex_color do
        partial 'color_picker'
      end
      field :font_color do
        partial 'color_picker'
      end
    end
  end

 config.model 'ArtistEvent' do
  edit do
    field :artist
    field :event
    field :set_start_time
    field :set_end_time
    field :live, :boolean
  end
end



end
