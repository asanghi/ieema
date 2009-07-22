require 'test_helper'

class FormulasControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Formula.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Formula.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Formula.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to formula_url(assigns(:formula))
  end
  
  def test_edit
    get :edit, :id => Formula.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Formula.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Formula.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Formula.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Formula.first
    assert_redirected_to formula_url(assigns(:formula))
  end
  
  def test_destroy
    formula = Formula.first
    delete :destroy, :id => formula
    assert_redirected_to formulas_url
    assert !Formula.exists?(formula.id)
  end
end
