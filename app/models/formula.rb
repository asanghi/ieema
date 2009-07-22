class Formula < ActiveRecord::Base

  belongs_to :category
  has_many :formula_components, :include => [:commodity => :commodity_prices]
  has_many :commodities, :through => :formula_components

  validates_presence_of :category_id, :name
  validates_numericality_of :buffer, :allow_blank => true

  attr_reader :billing_date, :tender_date

  def billing_date=(val)
    @billing_date = Chronic.parse(val).try(:to_date) || raise("Unable to parse billing date #{val}")
  end

  def tender_date=(val)
    @tender_date = Chronic.parse(val).try(:to_date) || raise("Unable to parse tender date #{val}")
  end

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
