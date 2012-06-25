class News::EntriesController < ApplicationController
  
  def index
    @news = News::Entry.all
  end

  def show
    @news_entry = News::Entry.find(params[:id])
    if @news_entry.nil?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
      return
    end
    @title = @news_entry.name
  end
  
end