require 'test_helper'

class AgencyJurisdictionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agency_jurisdictions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agency_jurisdiction" do
    assert_difference('AgencyJurisdiction.count') do
      post :create, :agency_jurisdiction => { }
    end

    assert_redirected_to agency_jurisdiction_path(assigns(:agency_jurisdiction))
  end

  test "should show agency_jurisdiction" do
    get :show, :id => agency_jurisdictions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => agency_jurisdictions(:one).to_param
    assert_response :success
  end

  test "should update agency_jurisdiction" do
    put :update, :id => agency_jurisdictions(:one).to_param, :agency_jurisdiction => { }
    assert_redirected_to agency_jurisdiction_path(assigns(:agency_jurisdiction))
  end

  test "should destroy agency_jurisdiction" do
    assert_difference('AgencyJurisdiction.count', -1) do
      delete :destroy, :id => agency_jurisdictions(:one).to_param
    end

    assert_redirected_to agency_jurisdictions_path
  end
end
