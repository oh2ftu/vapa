class AddDepartmentRefToIdentifiers < ActiveRecord::Migration
  def change
    add_reference :identifiers, :department, index: true
  end
end
