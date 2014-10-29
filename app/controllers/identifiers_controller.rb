class IdentifiersController < ApplicationController
load_and_authorize_resource

  def index
    if current_user.superuser || current_user.paid
     @identifier = Identifier.all
    else
     @identifier = Identifier.where(department_id: current_user.department_id).all
    end
  end

  def show
    @identifier = Identifier.find(params[:id])
  end

  def new
    @identifier = Identifier.new
  end

  def edit
    @identifier = Identifier.find(params[:id])
  end

 def create
    @identifier = Identifier.new(identifier_params)
    @identifier.department_id = current_user.department_id

    if @identifier.save
      redirect_to @identifier, :flash => { :success => 'Identifier was successfully created.' }
    else
      render :action => 'new'
    end
  end


  def update
    @identifiers = Identifier.find(params[:id])

    if @identifier.update_attributes(identifier_params)
      redirect_to @identifier, :flash => { :success => 'Identifier was successfully updated.' }
    else
      render :action => 'edit'
    end
  end

 
  def destroy
    @identifier = Identifier.find(params[:id])
    @identifier.destroy
    redirect_to identifiers_path, :flash => { :success => 'Identifier was successfully deleted.' }
  end
 
  private
    def identifier_params
      params.require(:identifier).permit(:identifier, :name, :barcode, :item_ids,  {:item_ids => []})
    end
end
