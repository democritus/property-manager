require 'test_helper'

class MarketSegmentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => MarketSegment.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    MarketSegment.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    MarketSegment.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to market_segment_url(assigns(:market_segment))
  end
  
  def test_edit
    get :edit, :id => MarketSegment.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    MarketSegment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => MarketSegment.first
    assert_template 'edit'
  end
  
  def test_update_valid
    MarketSegment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => MarketSegment.first
    assert_redirected_to market_segment_url(assigns(:market_segment))
  end
  
  def test_destroy
    market_segment = MarketSegment.first
    delete :destroy, :id => market_segment
    assert_redirected_to market_segments_url
    assert !MarketSegment.exists?(market_segment.id)
  end
end
