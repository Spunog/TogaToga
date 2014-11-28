require 'test_helper'

class FavouritesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:one)
    @favourite = favourites(:one)
  end

  test "should get index" do
    get :index, user_id: @user
    assert_response :success
    assert_not_nil assigns(:favourites)
  end

  test "should create favourite" do
    assert_difference('Favourite.count') do
      post :create, post: {title: 'Some title'}
    end
   
    assert_redirected_to post_path(assigns(:post))
  end



end