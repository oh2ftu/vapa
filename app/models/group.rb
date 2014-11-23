class Group < ActiveRecord::Base
 has_paper_trail :ignore => [:updated_at]
 has_and_belongs_to_many :users, :dependent => :restrict_with_error
 belongs_to :department
 validates :name, presence: true, uniqueness: { case_sensitive: false }
end
