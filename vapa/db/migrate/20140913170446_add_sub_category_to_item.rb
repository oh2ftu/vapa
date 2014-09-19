class AddSubCategoryToItem < ActiveRecord::Migration
  def change
    add_reference :items, :sub_category, index: true
  end
end
