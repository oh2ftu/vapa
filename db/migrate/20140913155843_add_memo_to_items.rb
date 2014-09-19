class AddMemoToItems < ActiveRecord::Migration
  def change
    add_column :items, :memo, :text
  end
end
