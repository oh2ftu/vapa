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
	@item = Item.where("tagid = ?", params[:search])
        if @item.size == 1
         @item.update_all(last_seen: Date.today)
	 @item.update_all(tagged: true)
	 if !params[:weight].blank?
	 @item.update_all(weight: params[:weight])
	 end
        end
 end
 def copy
        @source = Item.find(params[:id])
        @item = @source.dup
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
      with_status_id: Status.options_for_select,
      with_vendor_id: Vendor.options_for_select,
      with_unit_id: Unit.options_for_select

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

    @items = Item.where(department_id: current_user.department_id).filterrific_find(@filterrific).page(params[:page])
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
  def tagid
   if request.xhr?
    a = Category.find(params[:category_id])
    b = SubCategory.find(params[:sub_category_id])
    c = 14
#    c = params[:purchased_at_date].strftime(%y)
    abc = a + b + c
    find = Item.where("tagid LIKE 'abc%'").last
    if find.size.nil?
     d = 01.to_s
    else
     d = find[-2,2].to_i +=1
     d = d.to_s.rjust(2, '0')
    end
    if Item.where("tagid = abc+d").size.nil?
    @tagid = abc + d
    end
   end
  end

  def create
    @item = Item.new(item_params)
    @item.department_id = current_user.department_id

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
