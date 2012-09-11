class Shop::ProductItemsController < ApplicationController

  def create
    product = ::Shop::Product.find(params[:product_id])
    @product_item = current_cart.add(product, params[:quantity])
    if @product_item && @product_item.save
      flash[:success] = I18n.t('shop.flash.product_added_to_cart', default: "#{product.name} has been successfully added to cart.", product_name: product.name)
    else
      flash[:error] = I18n.t('shop.flash.product_adding_to_cart_failed', default: "#{product.name} adding to cart failed.", product_name: product.name)
    end
    redirect_to :back
  end

end
