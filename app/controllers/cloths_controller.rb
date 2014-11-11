class ClothsController < ApplicationController
  before_action :set_cloth, only: [:show, :edit, :update, :destroy]
  respond_to :html
  def index
    @cloths = Cloth.where(department_id: current_user.department_id).all
    respond_with(@cloths)
  end

  def show
    respond_with(@cloth)
  end

  def new
    @cloth = Cloth.new
    respond_with(@cloth)
  end

  def edit
  end

  def create
    @cloth = Cloth.new(cloth_params)
    @cloth.department_id = current_user.department_id
    @cloth.save
    respond_with(@cloth)
  end

  def update
    @cloth.update(cloth_params)
    respond_with(@cloth)
  end

  def destroy
    @cloth.destroy
    respond_with(@cloth)
  end

  private
    def set_cloth
      @cloth = Cloth.find(params[:id])
    end

    def cloth_params
      params.require(:cloth).permit(:user_id, :name, :size, :amount, :issued, :department_id)
    end
end
