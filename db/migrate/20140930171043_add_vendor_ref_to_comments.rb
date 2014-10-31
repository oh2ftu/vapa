class AddVendorRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :vendor, index: true
  end
end
