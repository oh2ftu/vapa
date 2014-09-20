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
# app/models/student.rb
def self.options_for_sorted_by
  [
    ['Name (a-z)', 'description_asc'],
    ['Registration date (newest first)', 'created_at_desc'],
    ['Registration date (oldest first)', 'created_at_asc'],
    ['Warranty end date (last first)', 'warranty_until_desc'],
    ['Warranty end date (oldest first)', 'warranty_until_asc'],
    ['Lifetime end date (newest first)', 'lifetime_until_desc'],
    ['Lifetime end date (oldest first)', 'lifetime_until_asc'],
    ['Last seen date (newest first)', 'last_seen_desc'],
    ['Last seen date (oldest first)', 'last_seen_asc'],
    ['Category (a-z)', 'category_name_asc'],
    ['LUP (a-z)', 'lup_asc'],
    ['owner (a-z)', 'owner_asc'],
    ['owner (z-a)', 'owner_desc']
  ]
end


filterrific(
  default_settings: { sorted_by: 'description_desc' },
  filter_names: [
    :search_query,
    :sorted_by,
    :with_category_id
  ]
)
scope :search_query, lambda { |query|
  return nil  if query.blank?
  terms = query.downcase.split(/\s+/)
  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }

  num_or_conds = 5
  where(
    terms.map { |term|
      "(LOWER(items.make) LIKE ? OR LOWER(items.model) LIKE ? OR LOWER(items.description) LIKE ? OR LOWER(items.tagid) LIKE ? OR LOWER(items.serial) LIKE ?)"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
  )}

scope :sorted_by, lambda { |sort_option|
 direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
  case sort_option.to_s
  when /^created_at_/
    # Simple sort on the created_at column.
    # Make sure to include the table name to avoid ambiguous column names.
    # Joining on other tables is quite common in Filterrific, and almost
    # every ActiveRecord table has a 'created_at' column.
    order("items.created_at #{ direction }")
  when /^last_seen_/
    order("items.last_seen #{ direction }")
  when /^warranty_until_/
    order("items.warranty_until #{ direction }")
  when /^lifetime_until_/
    order("items.lifetime_until #{ direction }")
  when /^lup_/
    order("items.lup #{ direction }")
  when /^owner_/
    order("items.owner #{ direction }")

  when /^description_/
    # Simple sort on the name colums
    order("LOWER(items.description) #{ direction }")
#    order("LOWER(items.description) #{ direction }, LOWER(students.first_name) #{ direction }")
  when /^category_name_/
    # This sorts by a student's country name, so we need to include
    # the country. We can't use JOIN since not all students might have
    # a country.
    order("LOWER(categories.name) #{ direction }").includes(:category)
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
}

scope :with_category_id, lambda { |category_ids|
where(category: { name: category_name }).joins(:category)
}

include Tree


end


