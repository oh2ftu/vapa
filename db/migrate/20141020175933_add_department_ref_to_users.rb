class AddDepartmentRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :department, index: true
  end
end
