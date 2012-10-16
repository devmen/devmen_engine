class Realty::EntriesController < ApplicationController

  def index
    @realty = Realty::Entry.page(params[:page])
  end

  def show
    @realty_entry = Realty::Entry.find(params[:id])
    if @realty_entry.nil?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
      return
    end
    @title = @realty_entry.name
  end

end
