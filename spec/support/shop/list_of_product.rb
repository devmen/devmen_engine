shared_examples "a list of product" do
  include ActionView::Helpers
  include ApplicationHelper

  subject { page }

  context "without pictures" do
    before do
      products
      visit products_path
    end

    it "should contain link and data for each product" do
      products.each do |product|
        should have_selector("a[href='#{product_path(product)}']", text: product.name)
        should have_content(number_to_currency(product.price))
        should have_content(teaser(product.description))
      end
    end

    it "should contain form with a quantity field and a cart button for each product" do
      products.each do |product|
        within "form[method='post'][action='#{product_items_path(product_id: product)}']" do
          should have_selector("input[name='quantity']")
          should have_selector("input[type='submit']")
        end
      end
    end

    it "should create product item in a cart" do
      expect {
        within "form#cart_button-#{products[0].id}" do
          fill_in "quantity", with: 5
          find('input[type="submit"]').click
        end
        wait_until { find("#messages", visible: true) }
      }.to change(Shop::ProductItem, :count).by(1)
      within "#messages" do
        should have_selector('.alert-success')
      end
    end

    it "should not create product item in a cart" do
      expect {
        within "form#cart_button-#{products[0].id}" do
          fill_in "quantity", with: 0
          find('input[type="submit"]').click
        end
        wait_until { find("#messages", visible: true) }
      }.to_not change(Shop::ProductItem, :count)
      within "#messages" do
        should have_selector('.alert-error')
      end
    end
  end

  context "with pictures" do
    before do
      PictureUploader.enable_processing = true
      product_with_pictures
      visit products_path
    end

    after do
      PictureUploader.enable_processing = false
      remove_test_images(product_with_pictures.map(&:pictures).flatten)
    end

    it "should contain mini thumb of first picture for each product" do
      product_with_pictures.each do |product|
        picture = product.pictures.sort_by{ |p| p.id }.first
        should have_selector("img[src='#{picture.image_url(:mini)}']")
      end
    end
  end
end