class Formula < ActiveRecord::Base

  belongs_to :category
  has_many :formula_components, :include => [:commodity => :commodity_prices]
  has_many :commodities, :through => :formula_components

  validates_presence_of :category_id, :name
  validates_numericality_of :buffer, :allow_blank => true

  attr_accessor :billing_date, :tender_date

  def calculate
    buffer + formula_components.to_a.sum do |fc|
      fc.billing_date = billing_date
      fc.tender_date = tender_date
      fc.weighted_value
    end
  end

  def description
    descriptions = formula_components.map(&:description).join(" + ")
    "( #{buffer} + #{descriptions})"
  end

end
