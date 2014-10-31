class RemoveRefRoleFromUsers < ActiveRecord::Migration
  def change
    remove_reference :users, :role, index: true
  end
end
