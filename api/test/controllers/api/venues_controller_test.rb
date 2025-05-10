require "test_helper"

class Api::VenuesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_venues_index_url
    assert_response :success
  end

  test "should get show" do
    get api_venues_show_url
    assert_response :success
  end
end
