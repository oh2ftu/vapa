class ChangeCategoryTypes < ActiveRecord::Migration
  def change
	change_column :categories, :name, :string
        change_column :sub_categories, :name, :string
        change_column :comments, :place, :string
        change_column :items, :description, :string
        change_column :items, :model, :string
        change_column :items, :make, :string
        change_column :statuses, :name, :string
        change_column :units, :name, :string
        change_column :vendors, :name, :string
        change_column :vendors, :address, :string
        change_column :vendors, :city, :string
        change_column :vendors, :contact, :string
        change_column :vendors, :name, :string

  end
end
