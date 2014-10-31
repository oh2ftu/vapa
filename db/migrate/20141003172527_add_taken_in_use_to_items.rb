class AddTakenInUseToItems < ActiveRecord::Migration
  def change
    add_column :items, :into_use, :date
  end
end
