class Owner < ActiveRecord::Base
has_paper_trail
has_many :items, :dependent => :restrict_with_error
belongs_to :department
def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
end
end
