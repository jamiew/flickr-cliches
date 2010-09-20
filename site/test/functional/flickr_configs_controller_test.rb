require 'test_helper'

class FlickrConfigsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flickr_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flickr_config" do
    assert_difference('FlickrConfig.count') do
      post :create, :flickr_config => { }
    end

    assert_redirected_to flickr_config_path(assigns(:flickr_config))
  end

  test "should show flickr_config" do
    get :show, :id => flickr_configs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => flickr_configs(:one).to_param
    assert_response :success
  end

  test "should update flickr_config" do
    put :update, :id => flickr_configs(:one).to_param, :flickr_config => { }
    assert_redirected_to flickr_config_path(assigns(:flickr_config))
  end

  test "should destroy flickr_config" do
    assert_difference('FlickrConfig.count', -1) do
      delete :destroy, :id => flickr_configs(:one).to_param
    end

    assert_redirected_to flickr_configs_path
  end
end
