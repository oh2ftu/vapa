class ServiceEvent < ActiveRecord::Base
 has_and_belongs_to_many :comments, :dependent => :restrict_with_error
 has_and_belongs_to_many :sub_categories, :dependent => :restrict_with_error
 has_paper_trail :ignore => [:updated_at]
def get_barcode(number)
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
     require 'barby/outputter/svg_outputter'

     barcode = Barby::Code128B.new("#{number}")

     barcode.to_svg(xdim:2, height:40, margin:5)
  end

end
