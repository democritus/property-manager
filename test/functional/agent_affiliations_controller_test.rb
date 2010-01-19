require 'test_helper'

class AgentAffiliationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agent_affiliations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agent_affiliation" do
    assert_difference('AgentAffiliation.count') do
      post :create, :agent_affiliation => { }
    end

    assert_redirected_to agent_affiliation_path(assigns(:agent_affiliation))
  end

  test "should show agent_affiliation" do
    get :show, :id => agent_affiliations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => agent_affiliations(:one).to_param
    assert_response :success
  end

  test "should update agent_affiliation" do
    put :update, :id => agent_affiliations(:one).to_param, :agent_affiliation => { }
    assert_redirected_to agent_affiliation_path(assigns(:agent_affiliation))
  end

  test "should destroy agent_affiliation" do
    assert_difference('AgentAffiliation.count', -1) do
      delete :destroy, :id => agent_affiliations(:one).to_param
    end

    assert_redirected_to agent_affiliations_path
  end
end
