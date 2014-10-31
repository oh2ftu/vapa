class AddLifetimeToItems < ActiveRecord::Migration
  def change
    add_column :items, :life_time, :integer
    add_column :items, :warranty_time, :integer
  end
end
