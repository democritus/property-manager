require 'test_helper'

class CantonsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Canton.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Canton.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Canton.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to canton_url(assigns(:canton))
  end
  
  def test_edit
    get :edit, :id => Canton.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Canton.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Canton.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Canton.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Canton.first
    assert_redirected_to canton_url(assigns(:canton))
  end
  
  def test_destroy
    canton = Canton.first
    delete :destroy, :id => canton
    assert_redirected_to cantons_url
    assert !Canton.exists?(canton.id)
  end
end
