class CheckoutItem < ActiveRecord::Base
 belongs_to :item
 belongs_to :checkout
 scope :all_returned, -> { where(returned: false) }
end
