class CommodityPrice < ActiveRecord::Base

  belongs_to :commodity
  validates_presence_of :commodity_id, :price_date, :price
  validates_numericality_of :price

  named_scope :price_for, lambda{|d|{:conditions => ["month(price_date) = ? and year(price_date) = ?",d.month,d.year]}}
  named_scope :for_year, lambda{|*y|{:conditions => ["year(price_date) = ?",(y[0]||Date.today.year)]}}
  named_scope :details, {:order => 'price_date', :select => 'distinct(price_date)'}

  def price_date_formatted=(val)
    self.price_date = Date.parse(val)
  end
  
  def price_date_formatted
    price_date.try(:to_s,:month_and_year)
  end
  
end
