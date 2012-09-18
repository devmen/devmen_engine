require 'spec_helper'

describe Shop::CartsController do
  let(:current_cart) { create(:cart_with_products) }
  before { set_current_cart(current_cart) }

  describe "GET show" do
    it "assigns the current cart as @cart" do
      get :show
      assigns(:cart).should eq(current_cart)
    end

    it "assigns product items in the current cart as @product_items" do
      get :show
      assigns(:product_items).map(&:id).should eq(current_cart.product_items.map(&:id))
    end

    it "renders the :show view" do
      get :show
      response.should render_template :show
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:product_item) { current_cart.product_items[0] }
      let(:valid_attributes) do
        product_item_hash = {
          id: product_item.id,
          quantity: product_item.quantity + 1
        }
        { cart: { product_items_attributes: [product_item_hash] } }
      end

      it "updates the product_item in the cart" do
        put :update, valid_attributes
        current_cart.reload
        current_cart.product_items[0].quantity.should eq(product_item.quantity + 1)
      end

      it "deletes the product_item from the cart" do
        expect {
          valid_attributes[:cart][:product_items_attributes][0][:_destroy] = '1'
          put :update, valid_attributes
        }.to change(Shop::ProductItem, :count).by(-1)
      end

      it "sets the success flash message" do
        put :update, valid_attributes
        flash[:success].should be_present
      end

      it "renders the show view" do
        put :update, valid_attributes
        response.should render_template :show
      end

      it "redirects to new order url" do
        valid_attributes[:button] = 'checkout'
        put :update, valid_attributes
        response.should redirect_to new_order_path
      end
    end

    describe "with invalid params" do
      let(:product_item) { current_cart.product_items[0] }
      let(:invalid_attributes) do
        product_item_hash = {
          id: product_item.id,
          quantity: 0
        }
        { cart: { product_items_attributes: [product_item_hash] } }
      end

      it "does not update the product_item in the cart" do
        put :update, invalid_attributes
        current_cart.reload
        current_cart.product_items[0].quantity.should eq(product_item.quantity)
      end

      it "does not delete the product_item from the cart" do
        expect {
          invalid_attributes[:cart][:product_items_attributes][0].merge({ id: 0, _destroy: true })
          put :update, invalid_attributes
        }.to_not change(Shop::ProductItem, :count)
      end

      it "sets the error flash message" do
        put :update, invalid_attributes
        flash[:error].should be_present
      end

      it "renders the show view" do
        put :update, invalid_attributes
        response.should render_template :show
      end
    end
  end

end
