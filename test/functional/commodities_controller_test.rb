require 'test_helper'

class CommoditiesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Commodity.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Commodity.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Commodity.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to commodity_url(assigns(:commodity))
  end
  
  def test_edit
    get :edit, :id => Commodity.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Commodity.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Commodity.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Commodity.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Commodity.first
    assert_redirected_to commodity_url(assigns(:commodity))
  end
  
  def test_destroy
    commodity = Commodity.first
    delete :destroy, :id => commodity
    assert_redirected_to commodities_url
    assert !Commodity.exists?(commodity.id)
  end
end
