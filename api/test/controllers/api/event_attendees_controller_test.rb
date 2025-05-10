require "test_helper"

class Api::EventAttendeesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_event_attendees_create_url
    assert_response :success
  end

  test "should get destroy" do
    get api_event_attendees_destroy_url
    assert_response :success
  end
end
