class ApplicationController < ActionController::Base
  protect_from_forgery
  include UserSessionHelper

  before_filter :change_locale

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

  private
  def change_locale
    session[:locale] = params[:locale] if params[:locale].present?
    I18n.locale = session[:locale] if session[:locale].present?
  end
end

# Run hook wich could be defined in initializers
ActiveSupport.run_load_hooks(:application_controller, ApplicationController)
