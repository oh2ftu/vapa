class Item < ActiveRecord::Base
validates :category, :sub_category, :owner, :description, :vendor_id, :status_id, :life_time, :warranty_time, :unit_id, :purchased_at_date, presence: true
validates :tagid, presence: true, uniqueness: true
#validates :weight, numericality: { only_integer: true, greater_than: 0 }
belongs_to :department
belongs_to :category
belongs_to :sub_category
belongs_to :status
belongs_to :vendor
belongs_to :unit
belongs_to :owner
belongs_to :user, inverse_of: :items
has_and_belongs_to_many :identifiers, dependent: :destroy
has_and_belongs_to_many :comments, dependent: :destroy, inverse_of: :items
acts_as_taggable
has_paper_trail :ignore => [:updated_at]

scope :jackets, -> { where(sub_category_id: "16") }
scope :trousers, -> { where(sub_category_id: "17") }
scope :helmets, -> { where(sub_category_id: "18") }
scope :boots, -> { where(sub_category_id: "14") }
scope :pagers, -> { where(sub_category_id: "268") }
scope :headsets, -> { where(sub_category_id: "105") }
scope :filtered, -> { where(department_id: current_user.department_id) }
#acts_as_taggable_on :category, :sub_category, :owner
include Tree
has_ancestry :orphan_strategy => :rootify

self.per_page = 25

def pur_date(id)
 id = Item.find(id)
 if id.into_use.nil?
  d = id.purchased_at_date
 else
  d = id.into_use
 end
 return d
end

def self.last_seen
  item = Item.where("tagid = ?", params[:search])
  if item.size = 1
  item.update(last_seen: Date.today)
  end
end

def serv_overdue(id)
  id = Item.find(id)
  sd = id.comments.where(service: true)
  if id.service_interval == 0 || id.service_interval.blank?
   return false
  else
   tdate = sd.last.try(:created_at) || id.purchased_at_date
   if tdate + id.service_interval.year < Date.today
    return true
   else
    return false
   end
  end

end

def insp_overdue(id)

  id = Item.find(id)
  sd = id.comments.where(inspection: true)
  if id.inspection_interval == 0 || id.inspection_interval.blank?
   return false
  else
   tdate = sd.last.try(:created_at) || id.purchased_at_date
   if tdate + id.inspection_interval.month < Date.today
    return true
   else
    return false
   end
  end

end




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
    ['Registration date (desc)', 'created_at_desc'],
    ['Registration date (asc)', 'created_at_asc'],
    ['Warranty end date (desc)', 'warranty_until_desc'],
    ['Warranty end date (asc)', 'warranty_until_asc'],
    ['Lifetime end date (desc)', 'lifetime_until_desc'],
    ['Lifetime end date (asc)', 'lifetime_until_asc'],
    ['Last seen date (desc)', 'last_seen_desc'],
    ['Last seen date (asc)', 'last_seen_asc'],
#    ['Last inspection date (desc)', 'last_insp_desc'],
#    ['Last inspection date (asc)', 'last_insp_asc'],
#    ['Last service date (desc)', 'last_serv_desc'],
#    ['Last service date (asc)', 'last_serv_asc'],
    ['Category (a-z)', 'category_name_asc'],
    ['Category (z-a)', 'category_name_desc'],
    ['SubCategory (a-z)', 'subcategory_name_asc'],
    ['SubCategory (z-a)', 'subcategory_name_desc'],
    ['Status (a-z)', 'status_asc'],
    ['Status (z-a)', 'status_desc'],
    ['owner (a-z)', 'owner_asc'],
    ['owner (z-a)', 'owner_desc'],
    ['Vendor (a-z)', 'vendor_name_asc'],
    ['Vendor (z-a)', 'vendor_name_desc']
 
  ]
end


filterrific(
  default_settings: { sorted_by: 'tagid_asc' },
  filter_names: [
    :search_query,
    :sorted_by,
    :with_category_id,
    :with_sub_category_id,
    :with_status_id,
    :with_vendor_id,
    :with_owner_id,
    :with_tagged,
    :with_owner,
    :with_unit_id,
    :with_lup_not,
    :with_lup_only,
    :with_lup_inc_only,
    :with_lup_inc_not,
    :with_untagged_only,
    :with_owner_lup_only,
    :with_service_overdue,
    :with_inspection_overdue,
    :with_last_seen_overdue,
    :with_department_id,
    :with_unit_type_id,
    :with_tagged_only
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
  when /^tagid_/
    order("items.tagid #{ direction }")
  when /^created_at_/
    # Simple sort on the created_at column.
    # Make sure to include the table name to avoid ambiguous column names.
    # Joining on other tables is quite common in Filterrific, and almost
    # every ActiveRecord table has a 'created_at' column.
    order("items.created_at #{ direction }")
  when /^last_seen_/
    order("items.last_seen #{ direction }")
 when /^last_insp_/
    order("items.last_inspection #{ direction }")
 when /^last_serv_/
    order("items.last_service #{ direction }")
  when /^warranty_until_/
    order("items.purchased_at_date + items.warranty_time #{ direction }")
  when /^lifetime_until_/
    order("items.purchased_at_date + items.life_time #{ direction }")
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
scope :with_service_overdue, lambda {|flag|
  return nil  if 0 == flag
Item.joins("LEFT JOIN comments_items ON comments_items.item_id = items.id LEFT JOIN comments ON comments.id = comments_items.comment_id  AND comments.service='TRUE'")
        .joins("LEFT JOIN comments c2 ON c2.item_id=items.id AND c2.service='TRUE' AND (datediff(NOW(),  COALESCE(c2.created_at, items.into_use, items.purchased_at_date)) > items.service_interval * 365) AND c2.id <> comments.id")
	.where("datediff(NOW(), COALESCE(comments.created_at, items.into_use, items.purchased_at_date)) > items.service_interval * 365")
	.where("c2.id IS NULL")
	.where("items.service_interval IS NOT NULL AND items.service_interval > 0")
}
scope :with_sservice_overdue, lambda {|flag|
  return nil  if 0 == flag
Item.joins("LEFT JOIN comments ON comments.item_id=items.id AND comments.service='TRUE'")
        .joins("LEFT JOIN comments c2 ON c2.item_id=items.id AND c2.service='TRUE' AND (datediff(NOW(),  COALESCE(c2.created_at, items.into_use, items.purchased_at_date)) > items.service_interval * 365) AND c2.id <> comments.id")
        .where("datediff(NOW(), COALESCE(comments.created_at, items.into_use, items.purchased_at_date)) > items.service_interval * 365")
        .where("c2.id IS NULL")
        .where("items.service_interval IS NOT NULL AND items.service_interval > 0")
}
scope :with_inspection_overdue, lambda {|flag|
  return nil  if 0 == flag
Item.joins("LEFT JOIN comments ON comments.item_id=items.id AND comments.inspection='TRUE'")
        .joins("LEFT JOIN comments c2 ON c2.item_id=items.id AND c2.inspection='TRUE' AND (datediff(NOW(),  COALESCE(c2.created_at, items.into_use, items.purchased_at_date)) > items.inspection_interval * 30) AND c2.id <> comments.id")
        .where("datediff(NOW(), COALESCE(comments.created_at, items.into_use, items.purchased_at_date)) > items.inspection_interval * 30")
        .where("c2.id IS NULL")
        .where("items.inspection_interval IS NOT NULL AND items.inspection_interval > 0")
};
scope :with_last_seen_overdue, lambda {|flag|
  return nil  if 0 == flag
  where("last_seen < ?", 1.year.ago)
}

scope :with_tagged_only, lambda {|flag|
  return nil  if 0 == flag
  where(tagged: true)
}
scope :with_untagged_only, lambda {|flag|
  return nil  if 0 == flag
  where(tagged: [nil, false])
}
scope :with_lup_inc_only, lambda {|flag|
  return nil  if 0 == flag
  where(lup_inc: true)
}
scope :with_lup_inc_not, lambda {|flag|
  return nil  if 0 == flag
  where(lup_inc: [nil, false])
}
scope :with_lup_not, lambda {|flag|
  return nil  if 0 == flag
  where(lup: [nil, false])
}

scope :with_lup_only, lambda {|flag|
  return nil  if 0 == flag
  where(lup: true)
}
scope :with_owner_lup_only, lambda {|flag|
  return nil  if 0 == flag
  where(owner: "LUP")
}
scope :with_owner_id, lambda { |unit_ids|
  unit_ids = Owner.all.map(&:id) if unit_ids.blank? || (unit_ids.size == 1 && unit_ids[0].blank?) || (unit_ids.size == 2 && unit_ids[1].blank?)
  where(:owner_id => [*unit_ids])
}
scope :with_department_id, lambda { |unit_ids|
  unit_ids = Department.all.map(&:id) if unit_ids.blank? || (unit_ids.size == 1 && unit_ids[0].blank?) || (unit_ids.size == 2 && unit_ids[1].blank?)
  where(:department_id => [*unit_ids])
}
scope :with_category_id, lambda { |unit_ids|
  unit_ids = Category.all.map(&:id) if unit_ids.blank? || (unit_ids.size == 1 && unit_ids[0].blank?) || (unit_ids.size == 2 && unit_ids[1].blank?)
  where(:category_id => [*unit_ids])
}
scope :with_sub_category_id, lambda { |unit_ids|
  unit_ids = SubCategory.all.map(&:id) if unit_ids.blank? || (unit_ids.size == 1 && unit_ids[0].blank?) || (unit_ids.size == 2 && unit_ids[1].blank?)
  where(:sub_category_id => [*unit_ids])
}
scope :with_unit_id, lambda { |unit_ids|
  unit_ids = Unit.all.map(&:id) if unit_ids.blank? || (unit_ids.size == 1 && unit_ids[0].blank?) || (unit_ids.size == 2 && unit_ids[1].blank?)
  where(:unit_id => [*unit_ids])
}
scope :with_unit_type_id, lambda { |unit_ids|
  unit_ids = UnitType.all.map(&:id) if unit_ids.blank? || (unit_ids.size == 1 && unit_ids[0].blank?) || (unit_ids.size == 2 && unit_ids[1].blank?)
  where(:unit_id => [*unit_ids])
}
scope :with_status_id, lambda { |unit_ids|
  unit_ids = Status.all.map(&:id) if unit_ids.blank? || (unit_ids.size == 1 && unit_ids[0].blank?) || (unit_ids.size == 2 && unit_ids[1].blank?)
  where(:status_id => [*unit_ids])
}

scope :with_vendor_id, lambda { |vendor_ids|
  vendor_ids = Vendor.all.map(&:id) if vendor_ids.blank? || (vendor_ids.size == 1 && vendor_ids[0].blank?) || (vendor_ids.size == 2 && vendor_ids[1].blank?)
  where(:vendor_id => [*vendor_ids])
}



end


