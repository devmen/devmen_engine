class Shop::CategoriesController < InheritedResources::Base

  def index
    @categories = Shop::Category.all    
  end

  def show
    @category = Shop::Category.find(params[:id])    
    @products = Shop::Product.includes(:pictures).by_category(params[:id])
  end

end
