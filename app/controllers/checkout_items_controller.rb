class CheckoutItemsController < ApplicationController
load_and_authorize_resource
  before_action :set_checkout_item, only: [:show, :edit, :update, :destroy]
  respond_to :html



  def index
     @checkout_items = CheckoutItem.all
    respond_with(@checkout_items)
  end

  def show
    respond_with(@checkout_item)
  end

  def new
    @checkout_item = CheckoutItem.new
    respond_with(@checkout_item)
  end

  def edit
  end

  def create
    @checkout_item = CheckoutItem.new(checkout_item_params)
    @checkout_item.save
    respond_with(@checkout_item)
  end

  def update
    @checkout_item.update(checkout_item_params)
    respond_with(@checkout_item)
  end

  def destroy
    @checkout_item.destroy
    respond_with(@checkout_item)
  end

  private
    def set_checkout_item
      @checkout_item = CheckoutItem.find(params[:id])
    end

    def checkout_item_params
      params[:checkout_item]
    end
end
