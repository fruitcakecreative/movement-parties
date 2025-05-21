class ApplicationController < ActionController::Base
  include ActionController::Cookies
  include Devise::Controllers::Helpers

  protect_from_forgery with: :exception
end
