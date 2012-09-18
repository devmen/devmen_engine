class Shop::ProductItemsController < ApplicationController

  def create
    product = ::Shop::Product.find(params[:product_id]) rescue nil
    @product_item = current_cart.add(product, params[:quantity]) if product
    if @product_item && @product_item.save
      flash[:success] = I18n.t('shop.flash.product_added_to_cart', default: "#{product.name} has been successfully added to cart.",
                                product_name: product.name)
    else
      flash[:error] = I18n.t('shop.flash.product_adding_to_cart_failed', default: "#{product.present? ? product.name : 'Product'} adding to cart failed.",
                                product_name: product.present? ? product.name : Shop::Product.human_attribute_name(:name))
    end
    redirect_to :back
  end

end
