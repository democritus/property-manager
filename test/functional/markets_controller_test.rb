require 'test_helper'

class MarketsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:markets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create market" do
    assert_difference('Market.count') do
      post :create, :market => { }
    end

    assert_redirected_to market_path(assigns(:market))
  end

  test "should show market" do
    get :show, :id => markets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => markets(:one).to_param
    assert_response :success
  end

  test "should update market" do
    put :update, :id => markets(:one).to_param, :market => { }
    assert_redirected_to market_path(assigns(:market))
  end

  test "should destroy market" do
    assert_difference('Market.count', -1) do
      delete :destroy, :id => markets(:one).to_param
    end

    assert_redirected_to markets_path
  end
end
