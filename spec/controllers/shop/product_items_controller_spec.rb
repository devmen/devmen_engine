require 'spec_helper'

describe Shop::ProductItemsController do

  describe "POST create" do
    let(:product) { create(:product) }
    let(:valid_attributes) { { product_id: product.id, quantity: 1 } }
    before { request.env["HTTP_REFERER"] = products_path }

    describe "with valid params" do
      it "creates a new product_item" do
        expect {
          post :create, valid_attributes
        }.to change(Shop::ProductItem, :count).by(1)
      end

      it "sets the success flash message" do
        post :create, valid_attributes
        flash[:success].should be_present
      end

      it "redirects to the back url" do
        post :create, valid_attributes
        response.should redirect_to products_path
      end
    end

    describe "with invalid params" do
      let(:invalid_attributes) { valid_attributes.merge({ quantity: 0 }) }
      it "does not create product_item for unknown product" do
        expect {
          post :create, valid_attributes.merge({ product_id: 0 })
        }.to_not change(Shop::ProductItem, :count)
      end

      it "does not create product_item for invalid quantity" do
        expect {
          post :create, invalid_attributes
        }.to_not change(Shop::ProductItem, :count)
      end

      it "sets the error flash message" do
        post :create, invalid_attributes
        flash[:error].should be_present
      end

      it "redirects to the back url" do
        post :create, invalid_attributes
        response.should redirect_to products_path
      end
    end
  end

end
