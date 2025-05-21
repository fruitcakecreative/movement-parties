Rails.application.config.session_store :cookie_store,
  key: "_movement_parties_session",
  same_site: :lax,
  secure: false
