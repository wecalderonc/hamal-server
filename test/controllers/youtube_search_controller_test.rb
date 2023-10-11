require "test_helper"

class YoutubeSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get youtube_search_search_url
    assert_response :success
  end
end
