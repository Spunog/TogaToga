require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @movie = movies(:one)
    @movie.images.build(url: 'http://cloud2.dev/image.jpg', type_id: 'fanart')
    @movie.images.build(url: 'http://cloud2.dev/image.jpg', type_id: 'poster')
    @movie.save!
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end

  test "should show movie" do
    get :show, id: @movie
    assert_response :success
  end

  test "should get rotten tomatoes json" do
    get :rt, id: @movie, :format => Mime::JSON
    assert_response :success
  end

  test "should get reddit json" do
    get :reddit, id: @movie, :format => Mime::JSON
    assert_response :success
  end  

  test "should get related json" do
    get :related, id: @movie, :format => Mime::JSON
    assert_response :success
  end  

end