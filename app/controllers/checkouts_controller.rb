class CheckoutsController < ApplicationController
load_and_authorize_resource
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  respond_to :html


  def index
    if current_user.superuser || current_user.paid
     @checkout = Checkout.all
    else
     @checkout = Checkout.where(department_id: current_user.department_id).all
    end
    respond_with(@checkouts)
  end

  def show
    respond_with(@checkout)
  end

  def new
    @checkout = Checkout.new
#    @checkout.department_id = current_user.department_id
    respond_with(@checkout)
  end

  def edit
  end

  def create
    @checkout = Checkout.new(checkout_params)
    @checkout.department_id = current_user.department_id
    @checkout.save
    respond_with(@checkout)
  end

  def update
    @checkout.update(checkout_params)
    respond_with(@checkout)
  end

  def destroy
    @checkout.destroy
    respond_with(@checkout)
  end

  private
    def set_checkout
      @checkout = Checkout.find(params[:id])
    end

    def checkout_params
      params.require(:checkout).permit(:user_id, :checkout, :return, :item_ids,  {:item_ids => []}, :returned, :department_id, :presel)
    end
end
