class Item < ActiveRecord::Base
validates :category, :sub_category, :owner, :description, presence: true
validates :weight, numericality: { only_integer: true, greater_than: 0 }
belongs_to :category
belongs_to :sub_category
has_many :identifiers, dependent: :destroy
has_many :comments, dependent: :destroy
acts_as_taggable
#acts_as_taggable_on :category, :sub_category, :owner
#has_ancestry
def self.import(file)
  CSV.foreach(file.path, headers: true) do |row|
    item = find_by_id(row["id"]) || new
    item.attributes = row.to_hash.slice
    item.save
  end
end

include Tree


end


