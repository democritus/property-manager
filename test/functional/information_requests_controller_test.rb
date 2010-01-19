require 'test_helper'

class InformationRequestsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:information_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create information_request" do
    assert_difference('InformationRequest.count') do
      post :create, :information_request => { }
    end

    assert_redirected_to information_request_path(assigns(:information_request))
  end

  test "should show information_request" do
    get :show, :id => information_requests(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => information_requests(:one).to_param
    assert_response :success
  end

  test "should update information_request" do
    put :update, :id => information_requests(:one).to_param, :information_request => { }
    assert_redirected_to information_request_path(assigns(:information_request))
  end

  test "should destroy information_request" do
    assert_difference('InformationRequest.count', -1) do
      delete :destroy, :id => information_requests(:one).to_param
    end

    assert_redirected_to information_requests_path
  end
end
