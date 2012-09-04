class Shop::ProductsController < InheritedResources::Base

  def index
    @products = Shop::Product.includes(:pictures).all
  end

  def show
    @product = Shop::Product.find(params[:id])
    # Use 301 redirect for all ids
    if request.path != product_path(@product)
      redirect_to product_path(@product), :status => :moved_permanently
    else
      @title = @product.name
    end    
  end

end
