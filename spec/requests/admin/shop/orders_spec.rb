require 'spec_helper'

describe 'Shop::Orders', js: true do
  include ActionView::Helpers
  include ApplicationHelper
  before { login_as_admin }
  subject { page }

  describe "list of orders" do
    let(:orders) { create_list(:order, 3) }
    before do
      orders
      visit admin_orders_path
    end

    it "should contain link and data for each order" do
      orders.each do |order|
        within "#order-#{order.id}" do
          should have_selector("a[href='#{admin_order_path(order)}']", text: order.num.to_s)
          should have_content(I18n.l(order.created_at, format: :long))
          should have_content(order.name)
          should have_content(order.email)
          should have_content(teaser(order.address))
        end
      end
    end
  end

  describe "order page" do
    let(:order) { create(:order_with_products_and_pictures) }
    let(:product_items) { order.product_items } # for shared examples of list of product item
    before do
      PictureUploader.enable_processing = true
      visit admin_order_path(order)
    end
    after do
      PictureUploader.enable_processing = false
      pictures = []
      order.product_items.each { |item| pictures << item.product.pictures }
      remove_test_images(pictures.flatten)
    end

    it "should contain order information" do
      should have_content(order.num)
      should have_content(order.name)
      should have_content(order.email)
      should have_content(order.address)
      should have_content(I18n.l(order.created_at, format: :long))
    end

    it_behaves_like "a list of product item"
  end

end