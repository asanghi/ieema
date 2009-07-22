class FormulaComponent < ActiveRecord::Base

  belongs_to :formula
  belongs_to :commodity

  validates_presence_of :formula_id, :commodity_id, :weight
  validates_numericality_of :weight
  validates_numericality_of :base_month_difference, :allow_blank => true

  before_save :setup_defaults

  attr_accessor :billing_date, :tender_date

  def billing_date_index
    commodity.price_for(billing_date).last.try(:price) || raise("Unable to find commodity index for #{commodity.name} for date #{billing_date}")
  end

  def effective_tender_date
    tender_date - base_month_difference.months
  end

  def tender_date_index
    commodity.price_for(effective_tender_date).last.try(:price) || raise("Unable to find commodity index for #{commodity.name} for date #{effective_tender_date}")
  end

  def weighted_value
    (weight * billing_date_index / tender_date_index).round(2)
  end

  def description
    "#{weight}*#{commodity.code}/#{commodity.code}0"
  end

  def descriptive_weight
    "#{weight} * [#{commodity.code}:#{billing_date_index}]/[#{commodity.code}0:#{tender_date_index}:#{effective_tender_date}] = #{weighted_value}"
  end

  private

  def setup_defaults
    self.weight ||= 1.0
    self.base_month_difference ||= 1
  end

end
