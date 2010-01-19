require 'test_helper'

class SiteTextsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => SiteText.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    SiteText.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    SiteText.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to site_text_url(assigns(:site_text))
  end
  
  def test_edit
    get :edit, :id => SiteText.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    SiteText.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SiteText.first
    assert_template 'edit'
  end
  
  def test_update_valid
    SiteText.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SiteText.first
    assert_redirected_to site_text_url(assigns(:site_text))
  end
  
  def test_destroy
    site_text = SiteText.first
    delete :destroy, :id => site_text
    assert_redirected_to site_texts_url
    assert !SiteText.exists?(site_text.id)
  end
end
