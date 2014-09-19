class Comment < ActiveRecord::Base

validates :commenter, :body, presence: true
validates :price, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :item
end
