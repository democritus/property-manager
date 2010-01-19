require 'test_helper'

class PropertyImagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:property_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create property_image" do
    assert_difference('PropertyImage.count') do
      post :create, :property_image => { }
    end

    assert_redirected_to property_image_path(assigns(:property_image))
  end

  test "should show property_image" do
    get :show, :id => property_images(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => property_images(:one).to_param
    assert_response :success
  end

  test "should update property_image" do
    put :update, :id => property_images(:one).to_param, :property_image => { }
    assert_redirected_to property_image_path(assigns(:property_image))
  end

  test "should destroy property_image" do
    assert_difference('PropertyImage.count', -1) do
      delete :destroy, :id => property_images(:one).to_param
    end

    assert_redirected_to property_images_path
  end
end
