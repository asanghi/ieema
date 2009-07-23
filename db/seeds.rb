Commodity.delete_all
aluminium = Commodity.create!(:name => 'Aluminium', :code => "AL")
zinc = Commodity.create!(:name => 'Zinc', :code => 'Zn')
fe = Commodity.create!(:name => 'Iron', :code => 'Fe')
heavy_angle = Commodity.create!(:name => 'Heavy Angle Steel', :code => 'HA')
light_angle = Commodity.create!(:name => 'Light Angle Steel', :code => 'LA')
labour = Commodity.create!(:name => 'Labour', :code => 'W')

Category.delete_all
tlah=Category.create!(:name => 'TLA & H')
tlt = Category.create!(:name => 'TLT')

FormulaComponent.delete_all
Formula.delete_all
tlah.formulas.create!(:name => 'With Aluminium & Steel', :buffer => 20,
  :formula_components_attributes => [
    {:weight => 40, :commodity => aluminium},
    {:weight => 5, :commodity => zinc},
    {:weight => 20, :commodity => light_angle},
    {:weight => 15, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}
  ])

tlah.formulas.create!(:name => 'Only Aluminium', :buffer => 20,
  :formula_components_attributes => [
    {:weight => 65, :commodity => aluminium},
    {:weight => 15, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}
  ])

tlah.formulas.create!(:name => 'Only Steel', :buffer => 20,
  :formula_components_attributes => [
    {:weight => 58, :commodity => light_angle},
    {:weight => 7, :commodity => zinc},
    {:weight => 15, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}
  ])

tlah.formulas.create!(:name => 'With Aluminium & Steel (old)', :buffer => 20,
  :formula_components_attributes => [
    {:weight => 40, :commodity => aluminium},
    {:weight => 5, :commodity => zinc},
    {:weight => 20, :commodity => fe},
    {:weight => 15, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}
  ])

tlah.formulas.create!(:name => 'Only Steel (old)', :buffer => 20,
  :formula_components_attributes => [
    {:weight => 58, :commodity => fe},
    {:weight => 7, :commodity => zinc},
    {:weight => 15, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}])

tlt.formulas.create(:name => 'Steel', :buffer => 15,
  :formula_components_attributes => [
    {:weight => 74, :commodity => light_angle},
    {:weight => 11, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}])

tlt.formulas.create(:name => 'Heavy and Light Angles', :buffer => 15,
  :formula_components_attributes => [
    {:weight => 18, :commodity => heavy_angle},
    {:weight => 40, :commodity => light_angle},
    {:weight => 16, :commodity => zinc},
    {:weight => 11, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}])

tlt.formulas.create(:name => 'Only HA & Zinc', :buffer => 15,
  :formula_components_attributes => [
    {:weight => 58, :commodity => heavy_angle},
    {:weight => 16, :commodity => zinc},
    {:weight => 11, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}])

tlt.formulas.create(:name => 'Only LA & Zinc', :buffer => 15,
  :formula_components_attributes => [
    {:weight => 58, :commodity => light_angle},
    {:weight => 16, :commodity => zinc},
    {:weight => 11, :commodity => labour,
      :billing_month_difference => 4,
      :tender_month_difference => 4}])

CommodityPrice.delete_all
require 'spreadsheet'

puts "Parsing Index Directory"
Spreadsheet.client_encoding = 'UTF-8'
workbook = Spreadsheet.open("#{RAILS_ROOT}/public/ieema.xls")
puts "Total #{workbook.worksheets.size} found"
workbook.worksheets.each do |ws|
  puts ws.name
  puts ws.row_count
  code = ws.row(0).at(0)
  commodity = Commodity.find_by_code(code)
  puts commodity.name
  ws.each(1) do |row|
    date = row.date(0)
    value = row.at(1).to_f
    commodity.commodity_prices.create!(:price => value,:price_date => date)
  end
end
