class UnitType < ActiveRecord::Base
  has_paper_trail :ignore => [:updated_at]
  has_many :units
 def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
 end
end
