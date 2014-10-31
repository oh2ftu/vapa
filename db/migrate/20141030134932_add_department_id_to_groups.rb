class AddDepartmentIdToGroups < ActiveRecord::Migration
  def change
    add_reference :groups, :department, index: true
  end
end
