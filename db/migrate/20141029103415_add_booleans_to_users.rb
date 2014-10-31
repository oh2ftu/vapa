class AddBooleansToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paid, :boolean, default: false
    add_column :users, :superuser, :boolean, default: false
  end
end
