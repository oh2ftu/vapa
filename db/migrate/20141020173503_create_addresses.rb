class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :city
      t.string :zip
      t.integer :addressable_id
      t.string :addressable_type

      t.timestamps
    end
	add_index :addresses, [:addressable_type, :addressable_id], :unique => true
  end
end
