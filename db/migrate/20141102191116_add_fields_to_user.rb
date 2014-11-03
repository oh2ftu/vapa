class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :jacket_size, :string
    add_column :users, :trouser_size, :string
    add_column :users, :boot_size, :string
    add_column :users, :vacancy, :string
  end
end
