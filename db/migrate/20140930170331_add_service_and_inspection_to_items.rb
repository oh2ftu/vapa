class AddServiceAndInspectionToItems < ActiveRecord::Migration
  def change
    add_column :items, :service, :boolean
    add_column :items, :inspection, :boolean
  end
end
