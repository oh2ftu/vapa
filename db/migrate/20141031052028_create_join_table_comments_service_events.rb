class CreateJoinTableCommentsServiceEvents < ActiveRecord::Migration
  def change
    create_join_table :comments, :service_events do |t|
      # t.index [:comment_id, :service_event_id]
      # t.index [:service_event_id, :comment_id]
    end
  end
end
