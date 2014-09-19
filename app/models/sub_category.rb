class SubCategory < ActiveRecord::Base
has_many :items, :dependent => :restrict_with_error
belongs_to :category
end
