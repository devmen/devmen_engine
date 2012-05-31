class Admin::BaseController < ApplicationController
  layout 'admin/application'

  def index
  end

  helper_method :page_list
  
  private

    def page_list
      @pages || Page.all
    end

end
