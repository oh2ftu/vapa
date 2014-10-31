class RemoveRefItemFromComments < ActiveRecord::Migration
  def change
    remove_reference :comments, :item, index: true
  end
end
