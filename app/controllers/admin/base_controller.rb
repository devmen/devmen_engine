class Admin::BaseController < ApplicationController
  layout 'admin/application'

  before_filter :default_elements

  def index
  end
  
  private

    def default_elements
      @pages ||= Page.all     
    end

end
