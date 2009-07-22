require 'test_helper'

class CommodityPricesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => CommodityPrice.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    CommodityPrice.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    CommodityPrice.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to commodity_price_url(assigns(:commodity_price))
  end
  
  def test_edit
    get :edit, :id => CommodityPrice.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    CommodityPrice.any_instance.stubs(:valid?).returns(false)
    put :update, :id => CommodityPrice.first
    assert_template 'edit'
  end
  
  def test_update_valid
    CommodityPrice.any_instance.stubs(:valid?).returns(true)
    put :update, :id => CommodityPrice.first
    assert_redirected_to commodity_price_url(assigns(:commodity_price))
  end
  
  def test_destroy
    commodity_price = CommodityPrice.first
    delete :destroy, :id => commodity_price
    assert_redirected_to commodity_prices_url
    assert !CommodityPrice.exists?(commodity_price.id)
  end
end
