# encoding: UTF-8
class Comment < ActiveRecord::Base
has_paper_trail
validates :user_id, presence: true
#validates :price, numericality: { only_integer: true, greater_than: 0 }

  has_and_belongs_to_many :items, inverse_of: :comments
  has_and_belongs_to_many :service_events
 belongs_to :vendor
 belongs_to :department
 belongs_to :user
end
