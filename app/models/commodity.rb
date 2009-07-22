class Commodity < ActiveRecord::Base

  has_many :formula_components
  has_many :formulas, :through => :formula_components
  has_many :commodity_prices, :order => 'price_date'

  validates_presence_of :name, :code

  def price_for(date)
    commodity_prices.price_for(date)
  end

  def base_ratio(billing_date,tender_date)
    commodity_prices.price_for(billing_date).last.price / commodity_prices.price_for(tender_date).last.price
  end

  def to_param
    "#{id}-#{code}"
  end

end
