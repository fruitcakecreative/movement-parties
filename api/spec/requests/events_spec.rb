require 'rails_helper'

RSpec.describe "Events API", type: :request do
  describe "GET /api/events" do
    it "returns success" do
      get "/api/events"
      expect(response).to have_http_status(:ok)
    end
  end
end
