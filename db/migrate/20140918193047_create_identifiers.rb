class CreateIdentifiers < ActiveRecord::Migration
  def change
    create_table :identifiers do |t|
      t.string :type
      t.string :barcode
      t.references :item, index: true

      t.timestamps
    end
  end
end
