class ApplicationController < ActionController::Base
# http_basic_authenticate_with name: "pj", password: "vpk"
before_action :authenticate_user!
before_action :configure_permitted_parameters, if: :devise_controller?
#load_and_authorize_resource
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
    ## to avoid deprecation warnings with Rails 3.2.x (and incidentally using Ruby 1.9.3 hash syntax)
    ## this render call should be:
    # render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  end  

protected

  def configure_permitted_parameters
  devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:department_id, :firstname, :lastname, :email, :password, :password_confirmation) }
  end
  protect_from_forgery with: :exception
  def info_for_paper_trail
    { :ip => request.remote_ip }
  end
end
