class AddMakeToItems < ActiveRecord::Migration
  def change
    add_column :items, :make, :text
    add_column :items, :model, :text
  end
end
