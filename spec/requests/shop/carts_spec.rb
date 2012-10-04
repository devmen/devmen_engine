require 'spec_helper'

describe 'Shop::Carts', js: true do
  include ActionView::Helpers

  let(:product_items) { create_list(:product_item_with_pictures, 2) }
  let(:pictures) { [] }
  before do
    PictureUploader.enable_processing = true
    product_items.each do |item|
      add_product_to_cart(item.product, item.quantity)
      pictures << item.product.pictures
    end
    visit cart_path
  end
  after do
    PictureUploader.enable_processing = false
    remove_test_images(pictures.flatten)
  end

  it_behaves_like "a list of product item", true

  describe "cart page" do
    subject { page }

    it "should contain form with action to current cart, save and checkout buttons" do
      within "form[method='post'][action='#{cart_path}']" do
        should have_button("checkout")
        should have_button("update")
      end
    end

    context "when update the cart" do

      it "should update quantity of product item" do
        product_items.each_with_index do |item, index|
          fill_in "cart[product_items_attributes][#{index}][quantity]", with: item.quantity + 1
        end
        find_button("update").click
        product_items.each_with_index do |item, index|
          should have_field("cart[product_items_attributes][#{index}][quantity]", value: item.quantity + 1)
        end
        wait_until { find("#messages", visible: true) }
        within "#messages" do
          should have_selector('.alert-success')
        end
      end

      it "should not update quantity of product item" do
        index = 0
        item = product_items[index]
        fill_in "cart[product_items_attributes][#{index}][quantity]", with: 0
        find_button("update").click
        should have_field("cart[product_items_attributes][#{index}][quantity]", value: item.quantity)
        wait_until { find("#messages", visible: true) }
        within "#messages" do
          should have_selector('.alert-error')
        end
      end

      it "should delete product item from the cart" do
        index = 0
        item = product_items[index]
        expect {
          check "cart[product_items_attributes][#{index}][_destroy]"
          find_button("update").click
          wait_until { find("#messages", visible: true) }
        }.to change(Shop::ProductItem, :count).by(-1)
        should_not have_content(item.product.name)
        within "#messages" do
          should have_selector('.alert-success')
        end
      end
    end

    context "when checkout an order" do

      it "should redirect to new order and not change product items in a cart" do
        expect {
          find_button("checkout").click
          wait_until { current_path == new_order_path }
        }.to_not change(Shop::ProductItem, :count)
        current_path.should eq(new_order_path)
      end

      it "should redirect to new order and change product items in a cart" do
        updated_index = 0
        deleted_index = 1
        updated_item = product_items[updated_index]
        deleted_item = product_items[deleted_index]
        expect {
          fill_in "cart[product_items_attributes][#{updated_index}][quantity]", with: updated_item.quantity + 1
          check "cart[product_items_attributes][#{deleted_index}][_destroy]"
          find_button("checkout").click
          wait_until { current_path == new_order_path }
        }.to change(Shop::ProductItem, :count).by(-1)
        current_path.should eq(new_order_path)
        within "#product_item-#{updated_index}" do
          should have_content(number_to_human(updated_item.quantity + 1, units: :product_units, precision: 0))
        end
      end

      it_behaves_like "a list of product item" do
        before do
          find_button("checkout").click
          wait_until { current_path == new_order_path }
        end
      end
    end
  end

end
