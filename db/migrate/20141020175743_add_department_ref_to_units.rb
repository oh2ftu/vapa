class AddDepartmentRefToUnits < ActiveRecord::Migration
  def change
    add_reference :units, :department, index: true
  end
end
