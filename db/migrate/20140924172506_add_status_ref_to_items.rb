class AddStatusRefToItems < ActiveRecord::Migration
  def change
    add_reference :items, :status, index: true
  end
end
