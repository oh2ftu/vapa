class AddNumberToUnitTypes < ActiveRecord::Migration
  def change
    add_column :unit_types, :acronym, :string
  end
end
