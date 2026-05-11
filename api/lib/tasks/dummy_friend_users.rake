# frozen_string_literal: true

namespace :dev do
  desc "Create dummy users for testing friendships (idempotent by email). Password for all: password"
  task dummy_friend_users: :environment do
    unless Rails.env.development?
      puts "This task is intended for development only."
      next
    end

    rows = [
      { name: "Friend Alpha", username: "friend_alpha", email: "friend_alpha@example.test" },
      { name: "Friend Beta", username: "friend_beta", email: "friend_beta@example.test" },
      { name: "Friend Gamma", username: "friend_gamma", email: "friend_gamma@example.test" },
      { name: "Friend Delta", username: "friend_delta", email: "friend_delta@example.test" },
      { name: "Friend Omega", username: "friend_omega", email: "friend_omega@example.test" }
    ]

    rows.each do |attrs|
      user = User.find_or_initialize_by(email: attrs[:email])
      if user.persisted?
        puts "Skip (exists): #{attrs[:email]}"
        next
      end

      user.assign_attributes(
        name: attrs[:name],
        username: attrs[:username],
        password: "password",
        password_confirmation: "password",
        picture: ""
      )
      user.save!
      puts "Created: #{attrs[:email]} (#{attrs[:username]})"
    end

    puts "Done. Sign in with any email above and password: password"
  end
end
