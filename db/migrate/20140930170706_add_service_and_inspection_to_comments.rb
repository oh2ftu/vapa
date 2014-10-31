class AddServiceAndInspectionToComments < ActiveRecord::Migration
  def change
    add_column :comments, :service, :boolean
    add_column :comments, :inspection, :boolean
  end
end
