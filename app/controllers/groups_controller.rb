class GroupsController < ApplicationController
  load_and_authorize_resource
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all
#    respond_with(@groups)
  end

  def show
#    respond_with(@group)
  end

  def new
    @group = Group.new
#    respond_with(@group)
  end

  def edit
  end


def create
    @group = Group.new(group_params)
    @group.department_id = current_user.department_id
    if @group.save
      redirect_to @group, :flash => { :success => 'Group was successfully created.' }
    else
      render :action => 'new'
    end
  end

  def update
    @groups = Group.find(params[:id])

    if @group.update_attributes(group_params)
      redirect_to @group, :flash => { :success => 'Group was successfully updated.' }
    else
      render :action => 'edit'
    end
  end


  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path, :flash => { :success => 'Group was successfully deleted.' }
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :department_id,  :user_ids,  {:user_ids => []})
    end
end
