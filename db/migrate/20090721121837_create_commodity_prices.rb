class CreateCommodityPrices < ActiveRecord::Migration
  def self.up
    create_table :commodity_prices do |t|
      t.integer :commodity_id
      t.date :price_date
      t.float :price
      t.timestamps
    end
  end
  
  def self.down
    drop_table :commodity_prices
  end
end
