class Role < ActiveRecord::Base
  has_paper_trail :ignore => [:updated_at]
  has_and_belongs_to_many :users
end
