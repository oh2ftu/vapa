class Comment < ActiveRecord::Base
has_paper_trail
validates :commenter, :body, presence: true
#validates :price, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :item
belongs_to :vendor
end
