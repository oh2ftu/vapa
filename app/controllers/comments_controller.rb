class CommentsController < ApplicationController
load_and_authorize_resource

  def index
    if current_user.superuser || current_user.paid
     @comment = Comment.where(department_id: current_user.department_id).all
    else
     @comment = Comment.all
    end
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
  end

  def edit
    @comment = Comment.find(params[:id])
  end

 def create
    @comment = Comment.new(comment_params)
    @comment.department_id = current_user.department_id
    if @comment.save
      redirect_to @comment, :flash => { :success => 'Comment was successfully created.' }
    else
      render :action => 'new'
    end
  end


  def update
    @comments = Comment.find(params[:id])

    if @comment.update_attributes(comment_params)
      redirect_to @comment, :flash => { :success => 'Comment was successfully updated.' }
    else
      render :action => 'edit'
    end
  end

 
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to comments_path, :flash => { :success => 'Comment was successfully deleted.' }
  end
 
  private
    def comment_params
      params.require(:comment).permit(:commenter, :body, :price, :place, :service, :inspection, :vendor_id, :item_ids,  {:item_ids => []}, :user_id, :service_event_ids, {:service_event_ids => []})
    end
end
