
Devise.setup do |config|

  # Ensure Devise controllers use the same CSRF/session stack as the rest of the app.
  config.parent_controller = "ApplicationController"

  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'

  config.omniauth :facebook, ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"]

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]


  config.stretches = Rails.env.test? ? 1 : 12



  config.reconfirmable = true


  config.expire_all_remember_me_on_sign_out = true

  config.remember_for = 2.weeks

  config.password_length = 6..128


  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/


  config.reset_password_within = 6.hours


  config.sign_out_via = :delete



  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other


  config.navigational_formats = []
end
