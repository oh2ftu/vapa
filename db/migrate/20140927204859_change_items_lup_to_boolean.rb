class ChangeItemsLupToBoolean < ActiveRecord::Migration
  def change
	change_column :items, :lup, :boolean
	change_column_default :items, :lup, false
  end
end
