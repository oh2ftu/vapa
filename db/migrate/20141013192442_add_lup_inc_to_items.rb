class AddLupIncToItems < ActiveRecord::Migration
  def change
    add_column :items, :lup_inc, :boolean
  end
end
