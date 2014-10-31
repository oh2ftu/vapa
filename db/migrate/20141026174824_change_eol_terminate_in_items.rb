class ChangeEolTerminateInItems < ActiveRecord::Migration
  def change
   change_column_null :items, :terminate_at_eol, false
   change_column_default :items, :terminate_at_eol, false
  end
end
