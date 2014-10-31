class AddIntervalsToItems < ActiveRecord::Migration
  def change
    add_column :items, :last_service, :date
    add_column :items, :last_inspection, :date
  end
end
