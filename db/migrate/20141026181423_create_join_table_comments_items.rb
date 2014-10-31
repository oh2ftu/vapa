class CreateJoinTableCommentsItems < ActiveRecord::Migration
  def change
   create_join_table :comments, :items
  end
end
