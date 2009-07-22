class CreateFormulas < ActiveRecord::Migration
  def self.up
    create_table :formulas do |t|
      t.integer :category_id
      t.string :name
      t.float :buffer
      t.timestamps
    end
  end
  
  def self.down
    drop_table :formulas
  end
end
