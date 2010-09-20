require 'test_helper'

class TagCategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tag_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag_category" do
    assert_difference('TagCategory.count') do
      post :create, :tag_category => { }
    end

    assert_redirected_to tag_category_path(assigns(:tag_category))
  end

  test "should show tag_category" do
    get :show, :id => tag_categories(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tag_categories(:one).to_param
    assert_response :success
  end

  test "should update tag_category" do
    put :update, :id => tag_categories(:one).to_param, :tag_category => { }
    assert_redirected_to tag_category_path(assigns(:tag_category))
  end

  test "should destroy tag_category" do
    assert_difference('TagCategory.count', -1) do
      delete :destroy, :id => tag_categories(:one).to_param
    end

    assert_redirected_to tag_categories_path
  end
end
