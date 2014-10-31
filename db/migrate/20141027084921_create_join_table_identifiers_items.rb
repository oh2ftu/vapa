class CreateJoinTableIdentifiersItems < ActiveRecord::Migration
  def change
   create_join_table :identifiers, :items
  end
end
