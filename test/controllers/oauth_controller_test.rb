require "test_helper"

class OauthControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get oauth_index_url
    assert_response :success
  end
end
