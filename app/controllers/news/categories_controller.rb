class News::CategoriesController < ApplicationController
  def index
    @categories = News::Category.all
  end

  def show
    @category = News::Category.find(params[:id])
    @news = News::Entry.by_category(params[:id]).page(params[:page])
  end
end
