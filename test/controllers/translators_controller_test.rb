require 'test_helper'

class TranslatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get translators_index_url
    assert_response :success
  end

end
