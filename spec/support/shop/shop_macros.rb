module Shop
  module Macros

    def set_current_cart(cart)
      session[:cart_id] = cart.id
      cart
    end

    def stub_current_cart(cart)
      controller.stub!(:current_cart).and_return(cart)
    end

    def add_product_to_cart(product, quantity = 1)
      visit product_path(product)
      within "form#cart_button-#{product.id}" do
        fill_in "quantity", with: quantity
        find('input[type="submit"]').click
      end
    end

  end
end