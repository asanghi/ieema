Commodity.delete_all
aluminium = Commodity.create(:name => 'Aluminium', :code => "AL")
zinc = Commodity.create(:name => 'Zinc', :code => 'Zn')
heavy_angle = Commodity.create(:name => 'Heavy Angle Steel', :code => 'HA')
light_angle = Commodity.create(:name => 'Light Angle Steel', :code => 'LA')
labour = Commodity.create(:name => 'Labour', :code => 'W')

Category.delete_all
tlah=Category.create(:name => 'TLA & H')
tlt = Category.create(:name => 'TLT')

FormulaComponent.delete_all
Formula.delete_all
wals = tlah.formulas.create(:name => 'With Aluminium & Steel', :buffer => 20)
wals.formula_components.create(:weight => 40, :commodity => aluminium)
wals.formula_components.create(:weight => 5, :commodity => zinc)
wals.formula_components.create(:weight => 20, :commodity => light_angle)
wals.formula_components.create(:weight => 15, :commodity => labour, :base_month_difference => 4)

oa = tlah.formulas.create(:name => 'Only Aluminium', :buffer => 20)
oa.formula_components.create(:weight => 65, :commodity => aluminium)
oa.formula_components.create(:weight => 15, :commodity => labour, :base_month_difference => 4)

os = tlah.formulas.create(:name => 'Only Steel', :buffer => 20)
os.formula_components.create(:weight => 58, :commodity => light_angle)
os.formula_components.create(:weight => 7, :commodity => zinc)
os.formula_components.create(:weight => 15, :commodity => labour, :base_month_difference => 4)

os2 = tlt.formulas.create(:name => 'Steel', :buffer => 15)
os2.formula_components.create(:weight => 74, :commodity => light_angle)
os2.formula_components.create(:weight => 11, :commodity => labour, :base_month_difference => 4)

hla = tlt.formulas.create(:name => 'Heavy and Light Angles', :buffer => 15)
hla.formula_components.create(:weight => 18, :commodity => heavy_angle)
hla.formula_components.create(:weight => 40, :commodity => light_angle)
hla.formula_components.create(:weight => 16, :commodity => zinc)
hla.formula_components.create(:weight => 11, :commodity => labour, :base_month_difference => 4)

oha = tlt.formulas.create(:name => 'Only HA & Zinc', :buffer => 15)
oha.formula_components.create(:weight => 58, :commodity => heavy_angle)
oha.formula_components.create(:weight => 16, :commodity => zinc)
oha.formula_components.create(:weight => 11, :commodity => labour, :base_month_difference => 4)

olaz = tlt.formulas.create(:name => 'Only LA & Zinc', :buffer => 15)
olaz.formula_components.create(:weight => 58, :commodity => light_angle)
olaz.formula_components.create(:weight => 16, :commodity => zinc)
olaz.formula_components.create(:weight => 11, :commodity => labour, :base_month_difference => 4)

CommodityPrice.delete_all
require 'parseexcel'
module Spreadsheet
  module ParseExcel
    class Workbook
      def worksheets
        @worksheets
      end
    end
  end
end

puts "Parsing Index Directory"
workbook = Spreadsheet::ParseExcel.parse("#{RAILS_ROOT}/public/ieema.xls")
puts "Total #{workbook.sheet_count} found"
workbook.worksheets.each do |ws|
  puts ws.name('latin1')
  puts ws.num_rows
  code = ws.row(0).at(0).to_s('latin1')
  start_date = ws.row(0).at(1).to_s('latin1').try(:to_date)
  commodity = Commodity.find_by_code(code)
  puts "#{commodity.name} #{start_date}"
  i = 0
  ws.each(1) do |row|
    commodity.commodity_prices.create!(:price => row.at(0).to_s('latin1').to_f, :price_date => start_date + i.months)
    i += 1
  end
end


=begin
commodities = [aluminium,zinc,light_angle,labour]
(2006..2010).to_a.each do |year|
  (1..12).to_a.each do |month|
    commodities.each do |c|
      c.commodity_prices.create(:price => rand(1000), :price_date => Date.new(year,month,1))
    end
  end
end
=end
