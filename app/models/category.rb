class Category < ActiveRecord::Base
has_many :items, :dependent => :restrict_with_error
has_many :sub_categories, :dependent => :restrict_with_error
def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
end

end
