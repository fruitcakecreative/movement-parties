Rails.application.config.session_store :cookie_store,
  key: "_event_app_session",
  same_site: :lax,
  secure: false
