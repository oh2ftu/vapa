class ApplicationController < ActionController::Base
# http_basic_authenticate_with name: "pj", password: "vpk"
before_action :authenticate_user!
#load_and_authorize_resource
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def info_for_paper_trail
    { :ip => request.remote_ip }
  end
end
