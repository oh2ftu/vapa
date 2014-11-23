class ItemsController < ApplicationController
#  http_basic_authenticate_with name: "pj", password: "vpk", except: [:index, :show]
  load_and_authorize_resource
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :prepare_categories
  require 'will_paginate/array'

  # GET /items
  # GET /items.json
def edit_multiple
  @items = Item.find(params[:item_ids])
end

def inventory

end

def update_multiple
  @items = Item.find(params[:item_ids])
  @items.reject! do |item|
    item.update_attributes(item_params.reject { |k,v| v.blank? })
  end
  if @items.empty?
    redirect_to items_url
  else
    @item = Item.new(params[:item])
    render "edit_multiple"
  end
end



 def history
	@versions = PaperTrail::Version.order('created_at DESC')
 end

 def last_seen
        if params[:search].nil?
         found = false
        else
 	 item_tag = Item.where("tagid = ?", params[:search])
         item_ser = Item.where("serial = ?", params[:search])
         item_ident = Identifier.where("barcode = ?", params[:search]).all
         if item_tag.size == 1
          @item = item_tag
          found_by = "tagid"
          found_tag = true
          found = true
         elsif item_tag.size == 0 && item_ser.size == 1
          @item = item_ser
          found_by = "serial"
          found = true
         elsif (item_ident.size == 1) && (item_ident.first.items.size == 1)
          @item = Item.where(id: item_ident.first.items.first.id)
          found_by = "identifier"
          found = true
         else
          found = false
          @item = item_tag
         end
        end
         if found == true
          item = @item.first
          item.update(last_seen: Date.today)
          if(found_by == "tagid")
   	   item.update(tagged: true)
	  end
          CheckoutItem.where("item_id = ?", item.id).where(returned: false).each do |t|
           t.update(returned: true)
          end
          if item.save
	   flash.now[:notice] = "Item #{item.to_label_user} updated, found by #{found_by}"
          end
	  if !params[:weight].blank?
	  item.update(weight: params[:weight])
	  end

        elsif (found == false) && (!params[:search].nil?)
         flash.now[:error] = "Not found"
        end
 end

 def copy
        @source = Item.find(params[:id])
        @item = @source.dup
        @item.tagged = false
	@item.tagid = nil
	if @item.serial?
	 @item.serial = nil
        end
        render 'new'
 end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_items] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end

  def index
    @filterrific = Filterrific.new(
      Item,
      params[:filterrific] || session[:filterrific_items]
    )
    @filterrific.select_options = {
      sorted_by: Item.options_for_sorted_by,
      with_category_id: Category.options_for_select,
      with_sub_category_id: SubCategory.options_for_select,
      with_owner_id: Owner.options_for_select,
      with_department_id: Department.options_for_select,
      with_status_id: Status.options_for_select,
      with_vendor_id: Vendor.options_for_select,
      with_unit_id: Unit.options_for_select,
      with_unit_type_id: UnitType.options_for_select

    }
#    @filterrific.select_options = {
#      sorted_by: Item.options_for_sorted_by,
#     with_status_id: Status.options_for_selec
#    }
#    @filterrific.select_options = {
#      sorted_by: Item.options_for_sorted_by,
#      with_vendor_id: Vendor.options_for_select
#    }




if params[:tag]
@items = Item.tagged_with(params[:tag]).arrange_as_array({:order => 'tagid'}).paginate(:per_page => 50, :page => params[:page])
##    @items = Item.all.paginate(:per_page => 10, :page => params[:page])
else
    if current_user.superuser || current_user.paid
    @items = Item.filterrific_find(@filterrific).page(params[:page])
   else
    @items = Item.where(department_id: current_user.department_id).filterrific_find(@filterrific).page(params[:page])
   end
end
    session[:filterrific_items] = @filterrific.to_hash
    respond_to do |format|
      format.html
      format.js
    end
rescue ActiveRecord::RecordNotFound
  redirect_to(action: :reset_filterrific) and return
#  end

#if params[:tag]
#@items = Item.tagged_with(params[:tag]).arrange_as_array({:order => 'id'}).paginate(:per_page => 20, :page => params[:page])
##    @items = Item.all.paginate(:per_page => 10, :page => params[:page])
#else
# @items = Item.arrange_as_array({:order => 'id'}).paginate(:per_page => 20, :page => params[:page])
#end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])   
    @versions = PaperTrail::Version.where(item_type: "Item", item_id: params[:id]).order('created_at DESC')

    @previous = Item.where("tagid < ?", params[:tagid]).order(:tagid).first   
    @next = Item.where("tagid > ?", params[:tagid]).order(:tagid).first 
  end

  # GET /items/new
  def new
    @item = Item.new
  end

def import
  Item.import(params[:file])
  redirect_to root_url, notice: "Items imported."
end
  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.department_id = current_user.department_id
    if item_params[:tagid].upcase.strip == "AUTO"
     @item.tagid = Item.tagid(item_params[:category_id], item_params[:sub_category_id], item_params[:purchased_at_date])
    end
    @item.tagid = @item.tagid.upcase
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
def prepare_categories
	@categories = Category.all
	@subcategories = SubCategory.all
end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:tagid, :rfid, :category_id, :sub_category_id, :weight, :description, :purchased_at_date, :vendor_id, :warranty_time, :lifetime_until, :serial, :sku, :price, :owner, :last_seen, :service_interval, :tagged, :status_id, :lup, :ancestry, :parent_id, :tag_list, :make, :model, :warranty_time, :life_time, :unit_id, :owner_id, :into_use, :ip, :inspection_interval, :item, :memo, :lup_inc, :search, :department_id, :user_id, :terminate_at_eol)
    end
end
