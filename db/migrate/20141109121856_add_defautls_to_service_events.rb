class AddDefautlsToServiceEvents < ActiveRecord::Migration
  def change
        change_column_null :service_events, :show, false
        change_column_default :service_events, :show, 0
  end
end
