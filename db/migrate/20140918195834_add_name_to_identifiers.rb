class AddNameToIdentifiers < ActiveRecord::Migration
  def change
    add_column :identifiers, :name, :string
  end
end
