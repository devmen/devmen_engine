class PagesController < ApplicationController

  def index
  end

  def show
    @page = Page.find_by_url(params[:page])
    if @page.nil?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
      return
    end
    @title = @page.name
  end

end
