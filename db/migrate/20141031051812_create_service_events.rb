class CreateServiceEvents < ActiveRecord::Migration
  def change
    create_table :service_events do |t|

      t.timestamps
    end
  end
end
