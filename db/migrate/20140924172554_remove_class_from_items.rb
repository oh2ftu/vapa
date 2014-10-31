class RemoveClassFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :item_class, :string
  end
end
