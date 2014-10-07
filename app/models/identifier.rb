class Identifier < ActiveRecord::Base
has_paper_trail
  belongs_to :item
end
