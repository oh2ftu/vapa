class Department < ActiveRecord::Base
  has_paper_trail :ignore => [:updated_at]
  has_many :checkouts, :dependent => :restrict_with_error
  has_many :users, :dependent => :restrict_with_error
  has_many :items, :dependent => :restrict_with_error
  has_many :units, :dependent => :restrict_with_error
  has_many :owners, :dependent => :restrict_with_error
  has_many :comments
  has_many :groups
  has_many :cloths
  has_one :address, :as => :addressable
  accepts_nested_attributes_for :address
def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
end
end
