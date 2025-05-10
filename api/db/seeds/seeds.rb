env = Rails.env.to_sym
seed_file = Rails.root.join("db", "seeds", "#{env}.rb")

if File.exist?(seed_file)
  puts "Seeding #{env}..."
  load seed_file
else
  puts "No seed file for #{env}"
end
