class Admin::BaseController < ApplicationController
  layout 'admin/application'

  before_filter :restrict_access

  def index
  end

  helper_method :page_list
  
  private

    def page_list
      @pages || Page.all
    end 

    def restrict_access
      unless current_user && current_user.role?(:admin)
        flash[:notice] = 'Please sign in to access this page.'
        redirect_to signin_path
      end
    end

end
