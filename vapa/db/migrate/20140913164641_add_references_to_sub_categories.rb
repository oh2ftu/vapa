class AddReferencesToSubCategories < ActiveRecord::Migration
  def change
	add_reference :sub_categories, :category, index: true
  end
end
