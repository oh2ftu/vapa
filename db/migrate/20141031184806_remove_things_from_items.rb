class RemoveThingsFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :sku, :string
    remove_column :items, :service, :boolean
    remove_column :items, :inspection, :boolean
  end
end
