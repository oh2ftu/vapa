class RemoveSubClassFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :item_subclass, :string
  end
end
