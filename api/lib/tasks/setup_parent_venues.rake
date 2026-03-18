# frozen_string_literal: true

namespace :db do
  desc "Set up parent venue relationships. Usage: rake db:setup_parent_venues"
  task setup_parent_venues: :environment do
    city = ENV["CITY"] || "mmw"

    # Define parent -> children. [child_name, subheading_for_display]
    # Parent is created if missing. Children are linked; subheading is the label in the grouped view.
    groups = {
      "Mode" => [
        ["Mode Above", "Above"],
        ["Mode Below", "Below"],
      ],
      "Mad Club" => [
        ["Mad Live", "Mad Live"],
      ],
      "Club Space" => [
        ["Club Space Miami", "Club Space"],
        ["The Ground Miami", "The Ground"],
      ],
      "Toe Jam Backlot" => [
        ["Toe Jam XL", "Toe Jam XL"],
      ],
    }

    parent_section_labels = {
      "Mode" => "Both Floors",
    }

    groups.each do |parent_name, children|
      parent = Venue.find_by(city_key: city, name: parent_name)
      unless parent
        parent = Venue.create!(city_key: city, name: parent_name)
        puts "Created parent: #{parent_name}"
      end

      if (label = parent_section_labels[parent_name])
        parent.update_column(:parent_section_label, label)
        puts "  Set parent_section_label: #{label}"
      end

      children.each do |child_name, subheading|
        child = Venue.where(city_key: city).find_by("LOWER(name) = ?", child_name.downcase)
        unless child
          child = Venue.create!(city_key: city, name: child_name)
          puts "  Created: #{child_name}"
        end

        if child.parent_venue_id != parent.id
          child.update!(parent_venue_id: parent.id)
          child.update_column(:subheading, subheading) if subheading.present?
          puts "  Linked: #{child.name} -> #{parent_name}"
        end
      end
    end

    Rails.cache.delete("events-v1:#{city}")
    puts "Done. Run imports to refresh cache."
  end
end
