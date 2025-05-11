env = Rails.env.to_sym
filename = env == :development ? "dev.rb" : "#{env}.rb"
seed_file = Rails.root.join("db", "seeds", filename)

if File.exist?(seed_file)
  puts "Seeding #{env}..."
  load seed_file
else
  puts "No seed file for #{env}"
end
