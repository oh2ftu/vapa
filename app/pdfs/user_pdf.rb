class UserPdf < Prawn::Document
 def initialize(user)
  super()
   @user = user
   text "Printed at #{Date.today}", size: 7
   move_down 10
   user_head
   user_info
   line_items
 end
 
 def user_head
  text "Department: #{@user.department.name}", size: 20, style: :bold
  text "User: \##{@user.vacancy} #{@user.firstname} #{@user.lastname}", size: 20, style: :bold
 end

 def line_items
  move_down 20
  table line_item_rows do
    row(0).font_style = :bold
    columns(1..3).align = :right
    self.row_colors = ["DDDDDD", "FFFFFF"]
    self.header = true
  end

 end

 def user_info
   move_down 20
   user_info_row(:jacket_size)
   user_info_row(:trouser_size)
   user_info_row(:boot_size)
 end

 def user_info_row(piece)
   text "#{piece.to_s.tr("_", " ").capitalize}: #{@user.send(piece.to_s).capitalize}"
 end

 def line_item_rows
  [["class", "Tagid", "Serial", "Issued", "Size", "Make", "model"]] + 
   scope_row(:jackets) +
   scope_row(:trousers) +
   scope_row(:boots) +
   scope_row(:helmets) +
#   [ {content: @user.department.name, colspan: 7}] + 
   scope_row(:headsets) +
   scope_row(:helmet_lights)
 end
 
 def scope_row(method)
   @user.items.send(method.to_s).map do |item|
   [method.to_s.tr("_", " ").singularize.capitalize, item.tagid, item.serial, item.into_use, item.size, item.make, item.model]
  end

 end
end
