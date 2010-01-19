require 'test_helper'

class AgencyLogosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agency_logos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agency_logo" do
    assert_difference('AgencyLogo.count') do
      post :create, :agency_logo => { }
    end

    assert_redirected_to agency_logo_path(assigns(:agency_logo))
  end

  test "should show agency_logo" do
    get :show, :id => agency_logos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => agency_logos(:one).to_param
    assert_response :success
  end

  test "should update agency_logo" do
    put :update, :id => agency_logos(:one).to_param, :agency_logo => { }
    assert_redirected_to agency_logo_path(assigns(:agency_logo))
  end

  test "should destroy agency_logo" do
    assert_difference('AgencyLogo.count', -1) do
      delete :destroy, :id => agency_logos(:one).to_param
    end

    assert_redirected_to agency_logos_path
  end
end
