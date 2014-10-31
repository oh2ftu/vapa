class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.text :name

      t.timestamps
    end
  end
end
