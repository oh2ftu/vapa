class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  has_paper_trail :ignore => [:updated_at]
end
