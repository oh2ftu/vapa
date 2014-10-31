class AddDepartmentRefToItems < ActiveRecord::Migration
  def change
    add_reference :items, :department, index: true
  end
end
