class RemoveRefItemFromIdentifiers < ActiveRecord::Migration
  def change
    remove_reference :identifiers, :item, index: true
  end
end
