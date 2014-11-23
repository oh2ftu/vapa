class Identifier < ActiveRecord::Base
has_paper_trail
  has_and_belongs_to_many :items, :dependent => :restrict_with_error
  validates :name, :barcode, presence: true
end
