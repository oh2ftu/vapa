class AddOwnerRefToItems < ActiveRecord::Migration
  def change
    add_reference :items, :owner, index: true
  end
end
