class AddDepartmentRefToCloths < ActiveRecord::Migration
  def change
    add_reference :cloths, :department, index: true
  end
end
