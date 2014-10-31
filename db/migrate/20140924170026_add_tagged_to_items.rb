class AddTaggedToItems < ActiveRecord::Migration
  def change
    add_column :items, :tagged, :boolean
  end
end
