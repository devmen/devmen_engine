class Realty::CategoriesController < ApplicationController
  def index
    @categories = Realty::Category.all
  end

  def show
    @category = Realty::Category.find(params[:id])
    @realty = Realty::Entry.by_category(params[:id]).page(params[:page])
  end
end
