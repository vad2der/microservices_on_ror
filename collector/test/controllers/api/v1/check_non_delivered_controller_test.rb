require 'test_helper'

class Api::V1::CheckNonDeliveredControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_check_non_delivered_index_url
    assert_response :success
  end

end
