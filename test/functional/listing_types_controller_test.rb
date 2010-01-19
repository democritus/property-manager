require 'test_helper'

class ListingTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:listing_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create listing_type" do
    assert_difference('ListingType.count') do
      post :create, :listing_type => { }
    end

    assert_redirected_to listing_type_path(assigns(:listing_type))
  end

  test "should show listing_type" do
    get :show, :id => listing_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => listing_types(:one).to_param
    assert_response :success
  end

  test "should update listing_type" do
    put :update, :id => listing_types(:one).to_param, :listing_type => { }
    assert_redirected_to listing_type_path(assigns(:listing_type))
  end

  test "should destroy listing_type" do
    assert_difference('ListingType.count', -1) do
      delete :destroy, :id => listing_types(:one).to_param
    end

    assert_redirected_to listing_types_path
  end
end
