class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.text :name
      t.text :address
      t.text :city
      t.text :contact
      t.string :phone
      t.string :email
      t.text :notes
      t.boolean :billing

      t.timestamps
    end
  end
end
