class AddEolTerminateToItems < ActiveRecord::Migration
  def change
    add_column :items, :terminate_at_eol, :boolean
  end
end
