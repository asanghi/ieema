require 'test_helper'

class CommodityPriceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert CommodityPrice.new.valid?
  end
end
