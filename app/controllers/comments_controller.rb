class CommentsController < ApplicationController
load_and_authorize_resource
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
  def index
    if current_user.superuser || current_user.paid
     @comment = Comment.all
    else
     @comment = Comment.where(department_id: current_user.department_id).all
    end
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
    @barcode = Barby::Code128.new('12345')

#    if !params[:item].nil?
#     @comment.item = params[:item]
#    end
  end

  def new_ts
    @comment = Comment.new
    render layout: false
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
      params.require(:comment).permit(:commenter, :body, :price, :place, :service, :inspection, :vendor_id, :item_ids,  {:item_ids => []}, :user_id, :service_event_ids, {:service_event_ids => []}, :presel)
    end
end
