class AddVendorRefToItems < ActiveRecord::Migration
  def change
    add_reference :items, :vendor, index: true
  end
end
