class ServiceEventsController < ApplicationController
load_and_authorize_resource

  def index
     @service_event = ServiceEvent.all
     respond_to do |format|
      format.html
#      format.pdf do
#       pdf = ServiceEventPdf.new(@service_event)
#       send_data pdf.render, filename: "ServiceEvents_#{Date.today}.pdf",
#                 type: "application/pdf",
#                 disposition: "inline"
#      end
     end
  end

  def show
    @service_event = ServiceEvent.find(params[:id])
  end

  def new
    @service_event = ServiceEvent.new
  end

  def edit
    @service_event = ServiceEvent.find(params[:id])
  end

 def create
    @service_event = ServiceEvent.new(service_event_params)
    if @service_event.save
      redirect_to @service_event, :flash => { :success => 'ServiceEvent was successfully created.' }
    else
      render :action => 'new'
    end
  end


  def update
    @service_events = ServiceEvent.find(params[:id])

    if @service_event.update_attributes(service_event_params)
      redirect_to @service_event, :flash => { :success => 'ServiceEvent was successfully updated.' }
    else
      render :action => 'edit'
    end
  end

 
  def destroy
    @service_event = ServiceEvent.find(params[:id])
    @service_event.destroy
    redirect_to service_events_path, :flash => { :success => 'ServiceEvent was successfully deleted.' }
  end
 
  private
    def service_event_params
      params.require(:service_event).permit(:name,  {:item_ids => []}, :user_id, :service_event_ids, {:service_event_ids => []}, :show, :sub_category_ids, {:sub_category_ids => []})
    end
end
