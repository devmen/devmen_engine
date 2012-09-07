class Shop::CartsController < InheritedResources::Base

  def show
    @cart = current_cart
    @product_items = @cart.product_items.includes(:product => :pictures)    
  end

  def update
    @cart = current_cart  
    if @cart.update_attributes(params[:cart])      
      if params[:button] == 'checkout'
        redirect_to new_order_path
        return
      else
        flash.now[:success] = I18n.t('shop.flash.cart_is_updated', default: "Your cart has been successfully updated.")        
      end
    else
      flash.now[:error] = I18n.t('shop.flash.cart_update_failed', default: "Your cart updated failed.")      
    end
    render :show
  end  

end
