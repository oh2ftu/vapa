class UnitType < ActiveRecord::Base
  has_paper_trail :ignore => [:updated_at]
  has_many :units
end
