require 'spec_helper'

describe 'Shop::Orders', js: true do
  include ActionView::Helpers

  let(:product_items) { create_list(:product_item_with_pictures, 2) }
  let(:pictures) { [] }
  before do
    PictureUploader.enable_processing = true
    product_items.each do |item|
      add_product_to_cart(item.product, item.quantity)
      pictures << item.product.pictures
    end
    visit new_order_path
  end
  after do
    PictureUploader.enable_processing = false
    remove_test_images(pictures.flatten)
  end

  it_behaves_like "a list of product item"

  describe "new order page" do
    subject { page }

    it "should contain form with action to create order, order fields, send button and back link" do
      within "form[method='post'][action='#{order_path}']" do
        should have_field("order[name]")
        should have_field("order[email]")
        should have_field("order[address]")
        should have_button("order")
        should have_link(:back)
      end
    end

    describe "create an order" do
      let(:order_attrs) { attributes_for(:order) }

      context "when invalid attribute values" do

        it "should not create an order, should show error message" do
          expect {
            expect {
              fill_in "order[name]", with: order_attrs[:name]
              fill_in "order[email]", with: order_attrs[:email]
              fill_in "order[address]", with: ""
              find_button("order").click
              wait_until { find("#messages", visible: true) }
            }.to_not change(Shop::Cart, :count)
          }.to_not change(Shop::Order, :count)
          current_path.should eq(order_path)
          within "#messages" do
            should have_selector('.alert-error')
          end
        end

      end

      context "when valid attribute values" do
        include EmailSpec::Helpers
        include EmailSpec::Matchers

        it "should create an order, redirect to root_path and show success message" do
          expect {
            expect {
              fill_in "order[name]", with: order_attrs[:name]
              fill_in "order[email]", with: order_attrs[:email]
              fill_in "order[address]", with: order_attrs[:address]
              find_button("order").click
              wait_until { current_path == root_path }
            }.to_not change(Shop::Cart, :count).by(-1)
          }.to change(Shop::Order, :count).by(1)
          current_path.should eq(root_path)
          within "#messages" do
            should have_selector('.alert-success')
          end
          # Check email delivery with customer data, rest is checked in controller spec
          order = Shop::Order.last
          open_last_email.should deliver_to order.email
          open_last_email.should have_body_text(/#{order.name}/)
          open_last_email.should have_body_text(/#{order.address}/)
          product_items.each { |item| open_last_email.should have_body_text %r{#{item.product.name}} }
        end

      end
    end
  end

end
