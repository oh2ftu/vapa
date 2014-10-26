class CommentsController < ApplicationController
load_and_authorize_resource
def create
    @item = Item.find(params[:item_id])
    @item.update(last_seen: Date.today)
    if(inspection = true)
	@item.update(last_inspection: Date.today)
    end
    if(service = true)
        @item.update(last_service: Date.today)
    end
    @comment = @item.comments.create(comment_params)
    redirect_to item_path(@item)
  end
 
  def destroy
    @item = Item.find(params[:item_id])
    @comment = @item.comments.find(params[:id])
    @comment.destroy
    redirect_to item_path(@item)
  end
 
  private
    def comment_params
      params.require(:comment).permit(:commenter, :body, :price, :place, :service, :inspection, :vendor_id)
    end
end
