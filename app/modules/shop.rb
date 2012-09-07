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

  end
end