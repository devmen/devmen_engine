class Shop::ProductItemsController < ApplicationController

  def create
    product = ::Shop::Product.find(params[:product_id]) rescue nil
    @product_item = current_cart.add(product, params[:quantity]) if product
    message = {}
    if @product_item && @product_item.save
      message[:success] = I18n.t('shop.flash.product_added_to_cart', default: "#{product.name} has been successfully added to cart.",
                                product_name: product.name)
    else
      message[:error] = I18n.t('shop.flash.product_adding_to_cart_failed', default: "#{product.present? ? product.name : 'Product'} adding to cart failed.",
                                product_name: product.present? ? product.name : Shop::Product.human_attribute_name(:name))
    end

    respond_to do |format|
      format.html do
        message.each{ |type, text| flash[type] = text }
        redirect_to :back
      end
      format.js do
        message.each{ |type, text| flash.now[type] = text }
        render partial: 'shop/cart'
      end
    end
  end

end
