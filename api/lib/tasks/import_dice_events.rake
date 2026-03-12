namespace :import do
  desc "Import DICE events from JSON"
  task dice_events: :environment do
    file_path = Rails.root.join("tmp", "dice_events.json")
    events = JSON.parse(File.read(file_path))

    puts "Found #{events.count} DICE events"

    events.each do |event_data|
      puts "Importing: #{event_data['title']}"
      # find/create/update logic here
    end
  end
end
