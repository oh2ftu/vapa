class SubCategory < ActiveRecord::Base
  has_paper_trail
  has_many :items, :dependent => :restrict_with_error
  belongs_to :category
def to_label_item
  "#{acronym} #{name}"
end

def self.options_for_select
  order('LOWER(name)').map { |e| [e.name, e.id] }
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
end
