require 'test_helper'

class FeatureAssignmentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feature_assignments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feature_assignment" do
    assert_difference('FeatureAssignment.count') do
      post :create, :feature_assignment => { }
    end

    assert_redirected_to feature_assignment_path(assigns(:feature_assignment))
  end

  test "should show feature_assignment" do
    get :show, :id => feature_assignments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => feature_assignments(:one).to_param
    assert_response :success
  end

  test "should update feature_assignment" do
    put :update, :id => feature_assignments(:one).to_param, :feature_assignment => { }
    assert_redirected_to feature_assignment_path(assigns(:feature_assignment))
  end

  test "should destroy feature_assignment" do
    assert_difference('FeatureAssignment.count', -1) do
      delete :destroy, :id => feature_assignments(:one).to_param
    end

    assert_redirected_to feature_assignments_path
  end
end
