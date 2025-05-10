# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_05_09_005703) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "artist_events", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "event_id", null: false
    t.datetime "set_start_time"
    t.datetime "set_end_time"
    t.boolean "live"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_artist_events_on_artist_id"
    t.index ["event_id"], name: "index_artist_events_on_event_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.bigint "genre_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ra_followers"
    t.index ["genre_id"], name: "index_artists_on_genre_id"
  end

  create_table "artists_events", id: false, force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "event_id", null: false
    t.index ["artist_id", "event_id"], name: "index_artists_events_on_artist_id_and_event_id"
    t.index ["event_id", "artist_id"], name: "index_artists_events_on_event_id_and_artist_id"
  end

  create_table "event_attendees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_attendees_on_event_id"
    t.index ["user_id"], name: "index_event_attendees_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.datetime "date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "venue_id", null: false
    t.string "source"
    t.text "description"
    t.string "event_url"
    t.integer "attending_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ticket_url"
    t.decimal "ticket_price", precision: 8, scale: 2
    t.string "ticket_tier"
    t.string "ticket_wave"
    t.string "font_color"
    t.boolean "manual_override"
    t.string "short_title"
    t.string "event_logo"
    t.string "even_shorter_title"
    t.boolean "free_event"
    t.boolean "food_available"
    t.string "indoor_outdoor"
    t.string "age"
    t.string "promoter"
    t.text "notes"
    t.string "bg_color"
    t.boolean "manual_override_ticket", default: false
    t.boolean "manual_override_location", default: false
    t.boolean "manual_override_times", default: false
    t.boolean "manual_override_genres", default: false
    t.boolean "manual_override_title"
    t.boolean "manual_override_artists"
    t.text "manual_artist_names"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "events_genres", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "genre_id", null: false
    t.index ["event_id"], name: "index_events_genres_on_event_id"
    t.index ["genre_id"], name: "index_events_genres_on_genre_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hex_color"
    t.string "short_name"
    t.string "font_color"
  end

  create_table "ticket_posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id", null: false
    t.string "price"
    t.string "looking_for"
    t.text "note"
    t.index ["event_id"], name: "index_ticket_posts_on_event_id"
  end

  create_table "user_events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_user_events_on_event_id"
    t.index ["user_id"], name: "index_user_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "profile_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "encrypted_password"
    t.string "username"
    t.string "avatar"
    t.string "picture"
    t.string "authentication_token"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_filename"
    t.string "bg_color"
    t.string "font_color"
    t.string "subheading"
    t.string "venue_type"
    t.string "serves_alcohol"
    t.text "notes"
    t.string "venue_url"
    t.string "address"
    t.text "description"
    t.integer "distance"
    t.text "additional_images"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artist_events", "artists"
  add_foreign_key "artist_events", "events"
  add_foreign_key "artists", "genres"
  add_foreign_key "event_attendees", "events"
  add_foreign_key "event_attendees", "users"
  add_foreign_key "events", "venues"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "ticket_posts", "events"
  add_foreign_key "user_events", "events"
  add_foreign_key "user_events", "users"
end
