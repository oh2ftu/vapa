class Checkout < ActiveRecord::Base
has_paper_trail
validates :user_id, presence: true
  belongs_to :department
  belongs_to :user
  has_many :checkout_items
  has_many :items, :through => :checkout_items

end
