require 'test_helper'

class OcrControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ocr_index_url
    assert_response :success
  end

end
