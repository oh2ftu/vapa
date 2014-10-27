class Comment < ActiveRecord::Base
has_paper_trail
validates :commenter, :body, presence: true
#validates :price, numericality: { only_integer: true, greater_than: 0 }

  has_and_belongs_to_many :items, inverse_of: :comments
belongs_to :vendor
end
