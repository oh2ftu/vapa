class Item < ActiveRecord::Base
validates :category, :sub_category, :owner, :description, :vendor_id, :status_id, :life_time, :warranty_time, :unit_id, presence: true
validates :tagid, presence: true, uniqueness: true
validates :weight, numericality: { only_integer: true, greater_than: 0 }, presence: true
belongs_to :category
belongs_to :sub_category
belongs_to :status
belongs_to :vendor
belongs_to :unit
has_many :identifiers, dependent: :destroy
has_many :comments, dependent: :destroy
acts_as_taggable
#acts_as_taggable_on :category, :sub_category, :owner
#has_ancestry

def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    item = find_by_id(row["id"]) || new
    item.attributes = row.to_hash.slice(*row.to_hash.keys)
    item.save!
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end

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
    ['Category (z-a)', 'category_name_desc'],
    ['SubCategory (a-z)', 'subcategory_name_asc'],
    ['SubCategory (z-a)', 'subcategory_name_desc'],
    ['LUP (a-z)', 'lup_asc'],
    ['Tagged (a-z)', 'tagged_asc'],
    ['Tagged (z-a)', 'tagged_desc'],
    ['Status (a-z)', 'status_asc'],
    ['Status (z-a)', 'status_desc'],
    ['owner (a-z)', 'owner_asc'],
    ['owner (z-a)', 'owner_desc'],
    ['Vendor (a-z)', 'vendor_name_asc'],
    ['Vendor (z-a)', 'vendor_name_desc']
 
  ]
end


filterrific(
  default_settings: { sorted_by: 'description_desc' },
  filter_names: [
    :search_query,
    :sorted_by,
    :with_category_id,
    :with_status_id,
    :with_vendor_id,
    :with_tagged,
    :with_owner,
    :with_unit_id

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
  when /^name_/
    order("items.description #{ direction }")
  when /^created_at_/
    # Simple sort on the created_at column.
    # Make sure to include the table name to avoid ambiguous column names.
    # Joining on other tables is quite common in Filterrific, and almost
    # every ActiveRecord table has a 'created_at' column.
    order("items.created_at #{ direction }")
  when /^last_seen_/
    order("items.last_seen #{ direction }")
  when /^warranty_until_/
    order("items.purchased_at_date + items.warranty_time #{ direction }")
  when /^lifetime_until_/
    order("items.purchased_at_date + items.life_time #{ direction }")
  when /^lup_/
    order("items.lup #{ direction }")
  when /^owner_/
    order("items.owner #{ direction }")
  when /^tagged_/
    order("items.tagged #{ direction }")
  when /^status_/
    order("items.status_id #{ direction }")
  when /^vendor_name_/
    order("items.vendor_id #{ direction }")

  when /^description_/
    # Simple sort on the name colums
    order("LOWER(items.description) #{ direction }")
#    order("LOWER(items.description) #{ direction }, LOWER(students.first_name) #{ direction }")
  when /^subcategory_name_/
    # This sorts by a student's country name, so we need to include
    # the country. We can't use JOIN since not all students might have
    # a country.
    order("LOWER(sub_categories.name) #{ direction }").joins(:sub_category)
  when /^category_name_/
    # This sorts by a student's country name, so we need to include
    # the country. We can't use JOIN since not all students might have
    # a country.
    order("LOWER(categories.name) #{ direction }").joins(:category)
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
}

scope :with_category_id, lambda { |category_ids|
  where(:category_id => [*category_ids])
}
scope :with_unit_id, lambda { |unit_ids|
  where(:unit_id => [*unit_ids])
}

scope :with_status_id, lambda { |status_ids|
  where(:status_id => [*status_ids])
}

scope :with_vendor_id, lambda { |vendor_ids|
  where(:vendor_id => [*vendor_ids])
}
#scope :with_tagged, lambda { |tagged|
#where(tagged: :tagged)
#}
#scope :with_category_id, lambda { |category_ids|
#where(category: { name: category_name }).joins(:category)
#}

include Tree


end


