class FormulaComponent < ActiveRecord::Base

  belongs_to :formula
  belongs_to :commodity

  validates_presence_of :formula_id, :commodity_id, :weight
  validates_numericality_of :weight
  validates_numericality_of :billing_month_difference, :allow_blank => true
  validates_numericality_of :tender_month_difference, :allow_blank => true

  before_save :setup_defaults

  attr_accessor :billing_date, :tender_date

  def effective_billing_date
    billing_date - billing_month_difference.months
  end

  def billing_date_index
    commodity.price_for(effective_billing_date).last.try(:price) || raise("Unable to find commodity index for #{commodity.name} for Billing Date : #{effective_billing_date.to_s(:month_and_year)}")
  end

  def effective_tender_date
    tender_date - tender_month_difference.months
  end

  def tender_date_index
    commodity.price_for(effective_tender_date).last.try(:price) || raise("Unable to find commodity index for #{commodity.name} for Tender Date : #{effective_tender_date.to_s(:month_and_year)}")
  end

  def weighted_value
    (weight * billing_date_index / tender_date_index).round(2)
  end

  def description
    "#{weight}*#{commodity.code}/#{commodity.code}0"
  end

  def descriptive_weight
    "#{weight} * [#{commodity.code}:#{billing_date_index}:#{effective_billing_date.to_s(:month_and_year)}]/[#{commodity.code}0:#{tender_date_index}:#{effective_tender_date.to_s(:month_and_year)}] = #{weighted_value}"
  end

  private

  def setup_defaults
    self.weight ||= 1.0
    self.tender_month_difference ||= 1
    self.billing_month_difference ||= 2
  end

end
