require 'test_helper'

class InfoControllerTest < ActionController::TestCase
  test "should get registrations" do
    get :registrations
    assert_response :success
  end

end
