class CreateCloths < ActiveRecord::Migration
  def change
    create_table :cloths do |t|
      t.references :user, index: true
      t.string :name
      t.string :size
      t.integer :amount
      t.date :issued

      t.timestamps
    end
  end
end
