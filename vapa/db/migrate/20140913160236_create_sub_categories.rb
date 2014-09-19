class CreateSubCategories < ActiveRecord::Migration
  def change
    create_table :sub_categories do |t|
      t.string :acronym
      t.text :name

      t.timestamps
    end
  end
end
