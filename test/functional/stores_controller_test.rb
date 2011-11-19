require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  test "should get groceries" do
    get :groceries
    assert_response :success
  end

end
