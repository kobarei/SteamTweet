require 'test_helper'

class SteamsControllerTest < ActionController::TestCase
  setup do
    @steam = steams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:steams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create steam" do
    assert_difference('Steam.count') do
      post :create, steam: { image: @steam.image, name: @steam.name, provider: @steam.provider, uid: @steam.uid, user_id: @steam.user_id }
    end

    assert_redirected_to steam_path(assigns(:steam))
  end

  test "should show steam" do
    get :show, id: @steam
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @steam
    assert_response :success
  end

  test "should update steam" do
    patch :update, id: @steam, steam: { image: @steam.image, name: @steam.name, provider: @steam.provider, uid: @steam.uid, user_id: @steam.user_id }
    assert_redirected_to steam_path(assigns(:steam))
  end

  test "should destroy steam" do
    assert_difference('Steam.count', -1) do
      delete :destroy, id: @steam
    end

    assert_redirected_to steams_path
  end
end
