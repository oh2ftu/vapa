class Vendor < ActiveRecord::Base
  has_paper_trail
  validates :name, presence: true, uniqueness: true
  has_many :items, :dependent => :restrict_with_error
  has_many :comments, :dependent => :restrict_with_error

def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    vendor = find_by_id(row["id"]) || new
    vendor.attributes = row.to_hash.slice(*row.to_hash.keys)
    vendor.save!
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
def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
end

end
