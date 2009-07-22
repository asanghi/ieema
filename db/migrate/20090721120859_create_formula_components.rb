class CreateFormulaComponents < ActiveRecord::Migration
  def self.up
    create_table :formula_components do |t|
      t.integer :formula_id
      t.integer :commodity_id
      t.float :weight
      t.integer :base_month_difference

      t.timestamps
    end
  end

  def self.down
    drop_table :formula_components
  end
end
