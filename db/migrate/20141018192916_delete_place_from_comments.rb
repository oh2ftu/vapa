class DeletePlaceFromComments < ActiveRecord::Migration
  def change
	remove_column :comments, :place, :string
        remove_column :items, :purchased_at, :text
        remove_column :items, :owner, :string
        remove_column :items, :last_service, :date
        remove_column :items, :last_inspection, :date
  end
end
