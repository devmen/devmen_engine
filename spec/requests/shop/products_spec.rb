require 'spec_helper'

describe 'Shop::Products', js: true do

  it_behaves_like "a list of product" do
    let(:products) { create_list(:product, 2) }
    let(:product_with_pictures) { create_list(:product_with_pictures, 2) }
  end

  describe "product page" do
    include ActionView::Helpers
    include ApplicationHelper

    subject { page }

    context "without pictures" do
      let(:product) { create(:product) }
      before { product; visit product_path(product) }
      it "should contain attribute values for product" do
        should have_content(product.name)
        should have_content(product.sku)
        should have_content(number_to_currency(product.price))
        should have_content(product.description)
      end
    end

    context "with pictures" do
      let(:product) { create(:product_with_pictures) }
      before do
        PictureUploader.enable_processing = true
        product
        visit product_path(product)
      end

      after do
        PictureUploader.enable_processing = false
        remove_test_images(product.pictures)
      end

      it "should contain thumbs and links of pictures" do
        product.pictures.each do |picture|
          within "a[href='#{picture.image_url}']" do
            should have_selector("img[src='#{picture.image_url(:thumb)}']")
          end
        end
      end
    end
  end

end
