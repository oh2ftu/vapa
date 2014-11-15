class AddConfirmOptsToUsers < ActiveRecord::Migration
  def change
  User.update_all(:confirmed_at => Time.now)
  end
end
