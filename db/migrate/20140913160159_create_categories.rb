class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :acronym
      t.text :name

      t.timestamps
    end
  end
end
