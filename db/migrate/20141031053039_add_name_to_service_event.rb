class AddNameToServiceEvent < ActiveRecord::Migration
  def change
    add_column :service_events, :name, :string
  end
end
