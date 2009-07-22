require 'test_helper'

class CommodityTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Commodity.new.valid?
  end
end
