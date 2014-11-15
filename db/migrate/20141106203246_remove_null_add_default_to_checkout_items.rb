class RemoveNullAddDefaultToCheckoutItems < ActiveRecord::Migration
  def change
        change_column_null :checkout_items, :returned, false
        change_column_default :checkout_items, :returned, 0
  end
end
