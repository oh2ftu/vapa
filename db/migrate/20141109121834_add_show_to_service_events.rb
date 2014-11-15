class AddShowToServiceEvents < ActiveRecord::Migration
  def change
    add_column :service_events, :show, :boolean
  end
end
