class Vendor < ActiveRecord::Base
validates :name, presence: true, uniqueness: true
has_many :items, :dependent => :restrict_with_error
def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
end

end
