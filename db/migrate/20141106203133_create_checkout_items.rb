class CreateCheckoutItems < ActiveRecord::Migration
  def change
    create_table :checkout_items do |t|
      t.references :item, index: true
      t.references :checkout, index: true
      t.boolean :returned

      t.timestamps
    end
  end
end
