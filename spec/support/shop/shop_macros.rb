module Shop
  module Macros

    def set_current_cart(cart)
      session[:cart_id] = cart.id
      cart
    end

  end
end