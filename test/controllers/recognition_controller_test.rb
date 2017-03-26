require 'test_helper'

class RecognitionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recognition_index_url
    assert_response :success
  end

end
