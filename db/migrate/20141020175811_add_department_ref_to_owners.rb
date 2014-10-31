class AddDepartmentRefToOwners < ActiveRecord::Migration
  def change
    add_reference :owners, :department, index: true
  end
end
