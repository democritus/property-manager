require 'test_helper'

class BarriosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:barrios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create barrio" do
    assert_difference('Barrio.count') do
      post :create, :barrio => { }
    end

    assert_redirected_to barrio_path(assigns(:barrio))
  end

  test "should show barrio" do
    get :show, :id => barrios(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => barrios(:one).to_param
    assert_response :success
  end

  test "should update barrio" do
    put :update, :id => barrios(:one).to_param, :barrio => { }
    assert_redirected_to barrio_path(assigns(:barrio))
  end

  test "should destroy barrio" do
    assert_difference('Barrio.count', -1) do
      delete :destroy, :id => barrios(:one).to_param
    end

    assert_redirected_to barrios_path
  end
end
