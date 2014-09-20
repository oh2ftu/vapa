class ItemsController < ApplicationController
  http_basic_authenticate_with name: "pj", password: "vpk", except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
before_filter :prepare_categories
require 'will_paginate/array'
  # GET /items
  # GET /items.json
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
      with_category_id: Category.options_for_select
    }
    @items = Item.filterrific_find(@filterrific).page(params[:page])
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
      params.require(:item).permit(:tagid, :rfid, :category_id, :sub_category_id, :weight, :description, :purchased_at_date, :purchased_at, :warranty_until, :lifetime_until, :serial, :sku, :price, :owner, :last_seen, :service_interval, :lup, :ancestry, :parent_id, :tag_list, :make, :model)
    end
end
