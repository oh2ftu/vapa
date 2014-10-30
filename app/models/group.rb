class Group < ActiveRecord::Base
 has_paper_trail
 has_and_belongs_to_many :users
 belongs_to :department
 validates :name, presence: true, uniqueness: true
end
