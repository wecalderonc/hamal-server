require "test_helper"

class DownloadsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get downloads_create_url
    assert_response :success
  end
end
