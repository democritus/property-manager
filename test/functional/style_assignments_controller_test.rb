require 'test_helper'

class StyleAssignmentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:style_assignments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create style_assignment" do
    assert_difference('StyleAssignment.count') do
      post :create, :style_assignment => { }
    end

    assert_redirected_to style_assignment_path(assigns(:style_assignment))
  end

  test "should show style_assignment" do
    get :show, :id => style_assignments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => style_assignments(:one).to_param
    assert_response :success
  end

  test "should update style_assignment" do
    put :update, :id => style_assignments(:one).to_param, :style_assignment => { }
    assert_redirected_to style_assignment_path(assigns(:style_assignment))
  end

  test "should destroy style_assignment" do
    assert_difference('StyleAssignment.count', -1) do
      delete :destroy, :id => style_assignments(:one).to_param
    end

    assert_redirected_to style_assignments_path
  end
end
