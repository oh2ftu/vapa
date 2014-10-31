class AddUnitTypeRefToUnits < ActiveRecord::Migration
  def change
    add_reference :units, :unit_type, index: true
  end
end
