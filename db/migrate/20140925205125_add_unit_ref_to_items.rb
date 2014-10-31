class AddUnitRefToItems < ActiveRecord::Migration
  def change
    add_reference :items, :unit, index: true
  end
end
