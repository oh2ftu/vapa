class Item < ActiveRecord::Base
validates :category, :sub_category, :tagid, :owner, :description, presence: true
validates :weight, numericality: { only_integer: true, greater_than: 0 }
validates :tagid, uniqueness: true
belongs_to :category
belongs_to :sub_category
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


