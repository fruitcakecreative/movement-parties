require "test_helper"

class Api::GenresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_genres_index_url
    assert_response :success
  end
end
