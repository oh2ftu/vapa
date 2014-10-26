class IdentifiersController < ApplicationController
load_and_authorize_resource
  def create
    @item = Item.find(params[:item_id])
    @identifier = @item.identifiers.create(ident_params)
    redirect_to item_path(@item)
  end
  def destroy
    @item = Item.find(params[:item_id])
    @identifier = @item.identifiers.find(params[:id])
    @identifier.destroy
    redirect_to item_path(@item)
  end
  private
    def ident_params
      params.require(:identifier).permit(:name, :barcode)
    end
end
