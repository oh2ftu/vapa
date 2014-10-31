class AddDepartmentRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :department, index: true
  end
end
