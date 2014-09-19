class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.text :place
      t.integer :price
      t.references :item, index: true

      t.timestamps
    end
  end
end
