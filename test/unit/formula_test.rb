require 'test_helper'

class FormulaTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Formula.new.valid?
  end
end
