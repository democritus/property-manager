require 'test_helper'

class AgencyRelationshipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agency_relationships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agency_relationship" do
    assert_difference('AgencyRelationship.count') do
      post :create, :agency_relationship => { }
    end

    assert_redirected_to agency_relationship_path(assigns(:agency_relationship))
  end

  test "should show agency_relationship" do
    get :show, :id => agency_relationships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => agency_relationships(:one).to_param
    assert_response :success
  end

  test "should update agency_relationship" do
    put :update, :id => agency_relationships(:one).to_param, :agency_relationship => { }
    assert_redirected_to agency_relationship_path(assigns(:agency_relationship))
  end

  test "should destroy agency_relationship" do
    assert_difference('AgencyRelationship.count', -1) do
      delete :destroy, :id => agency_relationships(:one).to_param
    end

    assert_redirected_to agency_relationships_path
  end
end
