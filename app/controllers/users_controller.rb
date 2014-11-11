class UsersController < ApplicationController
load_and_authorize_resource
#authorize! :assign_roles, @user if user_params[:assign_roles]
  def index
    if current_user.superuser
     @users = User.all
    else
     @users = User.where(department_id: current_user.department_id).all
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
     format.html
     format.pdf do
      pdf = UserPdf.new(@user)
      send_data pdf.render, filename: "varustekortti_#{@user.firstname}_#{@user.lastname}_#{Date.today}.pdf",
		type: "application/pdf",
		disposition: "inline"
     end
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, :flash => { :success => 'User was successfully created.' }
    else
      render :action => 'new'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
     authorize! :assign_roles, @user if params[:user][:assign_roles]
     sign_in(@user, :bypass => true) if @user == current_user
      redirect_to @user, :flash => { :success => 'User was successfully updated.' }
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, :flash => { :success => 'User was successfully deleted.' }
  end
    def user_params
      params.require(:user).permit(:email, :password, :firstname, :lastname, {:role_ids => []}, :role_ids, :department_id, :item_ids, {:item_ids => [] }, :phone, :jacket_size, :trouser_size, :boot_size, :vacancy)
    end

end
