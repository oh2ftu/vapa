class AddInspectionIntervalToItems < ActiveRecord::Migration
  def change
    add_column :items, :inspection_interval, :integer
    change_column :items, :lup, :boolean
  end
end
