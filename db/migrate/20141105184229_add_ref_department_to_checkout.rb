class AddRefDepartmentToCheckout < ActiveRecord::Migration
  def change
    add_reference :checkouts, :department, index: true
  end
end
