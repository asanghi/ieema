class Formula < ActiveRecord::Base

  belongs_to :category
  has_many :formula_components, :include => [:commodity => :commodity_prices], :dependent => :destroy
  has_many :commodities, :through => :formula_components

  validates_presence_of :category_id, :name
  validates_numericality_of :buffer, :allow_blank => true
  validate :total_component_sum
  validates_uniqueness_of :name, :scope => :category_id

  accepts_nested_attributes_for :formula_components, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs['weight'].blank? || attrs['weight'] == '0' || (attrs['commodity_id'].blank? && attrs['commodity'].blank?) }

  attr_reader :billing_date, :tender_date

  def billing_date=(val)
    @billing_date = Date.parse(val) || raise("Unable to parse billing date #{val}")
  end

  def tender_date=(val)
    @tender_date = Date.parse(val) || raise("Unable to parse tender date #{val}")
  end

  def name_full
    "#{category.name} #{name}"
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

  def total_component_sum
    fc = formula_components.reject{|x| x.blank? or (x.weight.blank?) or (x.weight == 0) }
    if !fc.empty? && (fc.sum(&:weight) + (buffer||0)) != 100.0
      errors.add(:base,"Total Component Weight + Buffer should be 100.0")
    end
  end

  def self.import!(workbook)
    Commodity.destroy_all
    Category.destroy_all
    category_sheet = workbook.worksheet("Categories")
    categories = {}
    category_sheet.each do |r|
      categories[r.at(0)] = Category.create!(:name => r.at(0))
    end
    commodity_sheet = workbook.worksheet("Commodities")
    commodities = {}
    commodity_sheet.each do |r|
      commodities[r[1]] = Commodity.create!(:name => r[0], :code => r[1].upcase)
    end
    formula_sheet = workbook.worksheet("Formulas")
    formulas = []
    formula_sheet.each do |r|
      formula_attributes = {}
      i = 0
      r.each_slice(4) do |s|
        if i == 0
          formula_attributes[:category] = categories[s[1]]
          formula_attributes[:name] = s[2]
          formula_attributes[:buffer] = s[3]
        else
          formula_attributes[:formula_components_attributes] ||= []
          formula_attributes[:formula_components_attributes] << {
            :commodity => commodities[s[0].upcase],
            :weight => s[1],
            :billing_month_difference => s[2],
            :tender_month_difference => s[3]
          }
        end
        i += 1
      end
      formulas << Formula.create!(formula_attributes)
    end
    prices_sheet = workbook.worksheet("Commodity Prices")
    row = prices_sheet.row(0)
    commodity_sequence = []
    row.each_with_index do |r,i|
      unless i == 0
        commodity_sequence << commodities[r.upcase]
      end
    end
    p = 0 
    prices_sheet.each(1) do |prow|
      price_date = Time.parse(prow[0])
      commodity_sequence.each_with_index do |c,i|
        unless prow[i+1].blank?
          c.commodity_prices.create!(:price_date => price_date, :price => prow[i+1])
          p += 1
        end
      end
    end
    return [commodities.size,formulas.size,p]
  end
end
