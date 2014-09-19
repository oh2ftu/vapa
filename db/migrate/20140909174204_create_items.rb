class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :tagid
      t.string :rfid
      t.string :item_class
      t.string :item_subclass
      t.integer :weight
      t.text :description
      t.date :purchased_at_date
      t.text :purchased_at
      t.date :warranty_until
      t.date :lifetime_until
      t.string :serial
      t.string :sku
      t.integer :price
      t.string :owner
      t.date :last_seen
      t.integer :service_interval
      t.boolean :lup

      t.timestamps
    end
  end
end
