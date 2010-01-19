require 'test_helper'

class AgencyImagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agency_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agency_image" do
    assert_difference('AgencyImage.count') do
      post :create, :agency_image => { }
    end

    assert_redirected_to agency_image_path(assigns(:agency_image))
  end

  test "should show agency_image" do
    get :show, :id => agency_images(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => agency_images(:one).to_param
    assert_response :success
  end

  test "should update agency_image" do
    put :update, :id => agency_images(:one).to_param, :agency_image => { }
    assert_redirected_to agency_image_path(assigns(:agency_image))
  end

  test "should destroy agency_image" do
    assert_difference('AgencyImage.count', -1) do
      delete :destroy, :id => agency_images(:one).to_param
    end

    assert_redirected_to agency_images_path
  end
end
