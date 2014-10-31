class ChangeWeightToDecimal < ActiveRecord::Migration
  def change
  change_column :items, :weight, :decimal, precision: 5, scale: 2
  end
end
