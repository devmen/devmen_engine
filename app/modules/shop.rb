module Shop
  module Helper

    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end

    def current_cart_destroy
      cart_id = session[:cart_id]
      Cart.destroy(cart_id)
      session[:cart_id] = nil
      cart_id
    end

    def check_current_cart
      if current_cart.product_items.empty?
        flash[:error] = I18n.t('shop.flash.cart_is_empty', default: "Your cart is empty.")
        redirect_to root_path
      end
    end

    def set_last_order_params(order)
      session[:last_order] = {
        name: order.name,
        email: order.email,
        address: order.address
      }
    end

    def last_order_params
      session[:last_order]
    end

  end
end