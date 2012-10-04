class ApplicationController < ActionController::Base
  protect_from_forgery
  include UserSessionHelper

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

end

# Run hook wich could be defined in initializers
ActiveSupport.run_load_hooks(:application_controller, ApplicationController)
