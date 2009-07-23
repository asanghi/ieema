class CommodityPrice < ActiveRecord::Base

  belongs_to :commodity
  validates_presence_of :commodity_id, :price_date, :price
  validates_numericality_of :price
  validates_uniqueness_of :price_date, :scope => :commodity_id

  named_scope :price_for, lambda{|d|{:conditions => ["month(price_date) = ? and year(price_date) = ?",d.month,d.year]}}
  named_scope :for_year, lambda{|*y|{:conditions => ["year(price_date) = ?",(y[0]||Date.today.year)]}}
  named_scope :details, {:order => 'price_date', :select => 'distinct(price_date)'}

  def price_date_formatted=(val)
    self.price_date = Date.parse(val)
  end
  
  def price_date_formatted
    price_date.try(:to_s,:month_and_year)
  end

  def self.import!(workbook)
    CommodityPrice.delete_all
    worksheet_count = 0
    commodity_prices_count = 0
    workbook.worksheets.each do |ws|
      code = ws.row(0).at(0)
      commodity = Commodity.find_by_code(code)
      ws.each(1) do |row|
        date = row.date(0)
        value = row.at(1).to_f
        commodity.commodity_prices.create!(:price => value,:price_date => date)
        commodity_prices_count += 1
      end
      worksheet_count += 1
    end
    [worksheet_count, commodity_prices_count]
  end
  
end
