require 'spec_helper'

describe Shop::OrdersController do
  let(:current_cart) { create(:cart_with_products) }
  before { set_current_cart(current_cart) }

  describe "GET new" do
    it "assigns a new order to @order" do
      get :new
      assigns(:order).should be_a_new(Shop::Order)
    end

    it "assigns product items in the current cart as @product_items" do
      get :new
      assigns(:product_items).map(&:id).should eq(current_cart.product_items.map(&:id))
    end

    it "renders the :new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST create" do
    let(:product_items) { current_cart.product_items }

    describe "with valid params" do
      let(:valid_params) { { order: attributes_for(:order) } }

      it "creates an order" do
        expect {
          post :create, valid_params
        }.to change(Shop::Order, :count).by(1)
      end

      it "moves product items from the current cart to an order" do
        post :create, valid_params
        order = Shop::Order.first
        order.product_items.map(&:id).sort.should eq(product_items.map(&:id).sort)
      end

      it "destroys a cart" do
        expect {
          post :create, valid_params
        }.to change(Shop::Cart, :count).by(-1)
      end

      it "destroys the current cart" do
        post :create, valid_params
        Shop::Cart.first(current_cart.id).should_not be_present
      end

      it "sets the success flash message" do
        post :create, valid_params
        flash[:success].should be_present
      end

      it "redirects to the root url" do
        post :create, valid_params
        response.should redirect_to root_path
      end

      it "delivers an email" do
        expect {
          post :create, valid_params
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end

      context "when deliver an email" do
        include EmailSpec::Helpers
        include EmailSpec::Matchers
        before { post :create, valid_params }
        let(:order) { Shop::Order.first }
        subject { open_last_email }

        it { should deliver_to order.email }
        it { should have_subject I18n.t('order_mail_message', default: "Order number #{order.num}", :num => order.num) }
        it { should have_body_text(/#{order.name}/) }
        it { should have_body_text(/#{order.num}/) }
        it { should have_body_text(/#{I18n.l(order.created_at.to_date, format: :long)}/) }
        it "contains ordered products" do
          product_items.each { |item| should have_body_text %r{#{item.product.name}} }
        end
      end

    end

    describe "with invalid params" do
      let(:invalid_params) { { order: attributes_for(:order).merge({ name: "", email: Faker::Lorem.words }) } }

      it "doesn't create an order" do
        expect {
          post :create, invalid_params
        }.to_not change(Shop::Order, :count)
      end

      it "doesn't remove product items from the current cart" do
        post :create, invalid_params
        ids = product_items.map(&:id).sort
        current_cart.reload
        current_cart.product_items.map(&:id).sort.should eq(ids)
      end

      it "doesn't destroy a cart" do
        expect {
          post :create, invalid_params
        }.to_not change(Shop::Cart, :count)
      end

      it "doesn't destroy the current cart" do
        post :create, invalid_params
        Shop::Cart.first(current_cart.id).should be_present
      end

      it "sets the error flash message" do
        post :create, invalid_params
        flash[:error].should be_present
      end

      it "renders the :new view" do
        post :create, invalid_params
        response.should render_template :new
      end

      it "doesn't deliver an email" do
        expect {
          post :create, invalid_params
        }.to_not change(ActionMailer::Base.deliveries, :size)
      end
    end
  end

end
