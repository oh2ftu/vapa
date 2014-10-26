class Unit < ActiveRecord::Base
  has_paper_trail
  belongs_to :department
  has_many :items, :dependent => :restrict_with_error
  belongs_to :unit_type
def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
end
end
