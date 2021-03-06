class Commodity < ActiveRecord::Base

  has_many :formula_components
  has_many :formulas, :through => :formula_components
  has_many :commodity_prices, :order => 'price_date', :dependent => :destroy

  validates_presence_of :name, :code
  validates_uniqueness_of :code

  accepts_nested_attributes_for :commodity_prices, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs['price_date'].blank? || attrs['price'].blank? }

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
