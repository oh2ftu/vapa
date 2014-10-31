class RemoveTypeFromIdentifiers < ActiveRecord::Migration
  def change
    remove_column :identifiers, :type, :string
  end
end
