require 'spec_helper'

describe 'Shop::Products', js: true do
  include ActionView::Helpers
  before { login_as_admin }
  subject { page }

  describe "list of products" do
    let(:root_categories) { create_list(:product_category, 2) }
    let(:sub_categories) { create_list(:product_category, 2, parent_id: root_categories[0].id) }
    let(:categories) { root_categories + sub_categories }
    let(:products_in_root_category) { create_list(:product_with_pictures, 2, category: root_categories[0]) }
    let(:products_in_sub_category) { create_list(:product_with_pictures, 2, category: sub_categories[0]) }
    let(:products) { products_in_root_category + products_in_sub_category }
    let(:orphaned_products) { create_list(:product_with_pictures, 2) }
    before do
      PictureUploader.enable_processing = true
      categories
      products
      orphaned_products
      visit admin_products_path
    end
    after do
      PictureUploader.enable_processing = false
      remove_test_images(products.map{|p| p.pictures}.flatten)
    end

    it "should contain add button, select by category, links and data for each product" do
      should have_selector("a[href='#{new_admin_product_path}']")
      (products + orphaned_products).each do |product|
        within "#product-#{product.id}" do
          picture = product.pictures.sort_by{ |p| p.id }.first
          should have_selector("img[src='#{picture.image_url(:thumb, :small)}']")
          should have_selector("a[href='#{admin_product_path(product)}']", text: product.name)
          should have_content(product.sku)
          should have_content(number_to_currency(product.price))
          should have_content(product.in_stock)

          should have_selector("a[href='#{edit_admin_product_path(product)}']")
          should have_selector("a[href='#{admin_product_path(product)}'][data-method='delete']")
        end
      end
      within "select[name='by_category']" do
        categories.each do |category|
          should have_selector("option[value='#{category.id}']", text: category.name)
        end
      end
    end

    context "when filter products" do

      it "should show products from root and sub categories" do
        page.select root_categories[0].name, from: "by_category"
        products.each do |product|
          should have_selector("a[href='#{admin_product_path(product)}']", text: product.name)
        end
      end

      it "should show products only from sub category" do
        page.select sub_categories[0].name, from: "by_category"
        products_in_sub_category.each do |product|
          should have_selector("a[href='#{admin_product_path(product)}']", text: product.name)
        end
        products_in_root_category.each do |product|
          should_not have_selector("a[href='#{admin_product_path(product)}']", text: product.name)
        end
      end

      it "should show only orphaned products" do
        visit admin_products_path(orphaned: true)
        orphaned_products.each do |product|
          should have_selector("a[href='#{admin_product_path(product)}']", text: product.name)
        end
        products.each do |product|
          should_not have_selector("a[href='#{admin_product_path(product)}']", text: product.name)
        end
      end
    end

    it "should delete a product" do
      product = products[0]
      expect {
        handle_js_confirm do
          find("a[href='#{admin_product_path(product)}'][data-method='delete']").click
        end
        wait_until { find("#messages", visible: true) }
      }.to change(Shop::Product, :count).by(-1)
      within "#messages" do
        should have_selector('.alert-success')
      end
      should_not have_selector("a[href='#{admin_product_path(product)}']", text: product.name)
    end

  end

  describe "product page" do
    let(:product) { create(:product_with_pictures) }
    before do
      PictureUploader.enable_processing = true
      visit admin_product_path(product)
    end
    after do
      PictureUploader.enable_processing = false
      remove_test_images(product.pictures)
    end

    it "should contain product name, data, description, edit and delete buttons and all pictures" do
      should have_content(product.name)
      should have_content(product.description)
      should have_content(product.sku)
      should have_content(number_to_currency(product.price))
      should have_content(product.in_stock)
      should have_selector("a[href='#{edit_admin_product_path(product)}']")
      should have_selector("a[href='#{admin_product_path(product)}'][data-method='delete']")
      product.pictures.each do |picture|
        within "a[href='#{picture.image_url}']"  do
          should have_selector("img[src='#{picture.image_url(:thumb)}']")
        end
      end
    end
  end

  describe "new product page" do
    let(:category) { create(:product_category) }
    before do
      category
      visit new_admin_product_path
    end

    it "should contain product form" do
      within "form[method='post'][action='#{admin_products_path}']" do
        should have_select("shop_product[category_id]")
        should have_field("shop_product[name]")
        should have_field("shop_product[sku]")
        should have_field("shop_product[price]")
        should have_field("shop_product[old_price]")
        should have_field("shop_product[in_stock]")
        should have_field("shop_product[description]")
        3.times { |i| should have_field("shop_product[pictures_attributes][#{i}][image]") }
        should have_button(:submit)
        should have_link(:back)
      end
    end

    it "should create new product" do
      attrs = attributes_for(:product)
      expect {
        page.select category.name, from: "shop_product[category_id]"
        fill_in "shop_product[name]", with: attrs[:name]
        fill_in "shop_product[price]", with: attrs[:price]
        fill_in "shop_product[description]", with: attrs[:description]
        find_button(:submit).click
        wait_until { find("#messages", visible: true) }
      }.to change(Shop::Product, :count).by(1)
      within "#messages" do
        should have_selector('.alert-success')
      end
    end

    it "should not create new product" do
      expect {
        find_button(:submit).click
        wait_until { find("#messages", visible: true) }
      }.to_not change(Shop::Category, :count)
      within "#messages" do
        should have_selector('.alert-error')
      end
    end

  end

  describe "edit product page" do
    let(:product) { create(:product_with_pictures) }
    before do
      PictureUploader.enable_processing = true
      visit edit_admin_product_path(product)
    end
    after do
      PictureUploader.enable_processing = false
      remove_test_images(product.pictures)
    end

    it "should contain product form" do
      within "form[method='post'][action='#{admin_product_path(product)}']" do
        should have_select("shop_product[category_id]")
        should have_field("shop_product[name]")
        should have_field("shop_product[sku]")
        should have_field("shop_product[price]")
        should have_field("shop_product[old_price]")
        should have_field("shop_product[in_stock]")
        should have_field("shop_product[description]")
        product.pictures.each_with_index do |picture, i|
          within "a[href='#{picture.image_url}']"  do
            should have_selector("img[src='#{picture.image_url(:thumb)}']")
          end
          should have_field("shop_product[pictures_attributes][#{i}][image]")
        end
        should have_button(:submit)
        should have_link(:back)
      end
    end

    it "should update the product and delete picture" do
      attrs = attributes_for(:product)
      fill_in "shop_product[name]", with: attrs[:name]
      fill_in "shop_product[description]", with: attrs[:description]
      deleted_picture = product.pictures[0]
      check "shop_product[pictures_attributes][0][_destroy]"
      find_button(:submit).click
      wait_until { find("#messages", visible: true) }
      within "#messages" do
        should have_selector('.alert-success')
      end
      visit edit_admin_product_path(product)
      should have_field("shop_product[name]", value: attrs[:name])
      should have_field("shop_product[description]", value: attrs[:description])
      should_not have_selector("img[src='#{deleted_picture.image_url(:thumb)}']")
    end

    it "should not update the product" do
      fill_in "shop_product[name]", with: ""
      find_button(:submit).click
      wait_until { find("#messages", visible: true) }
      within "#messages" do
        should have_selector('.alert-error')
      end
      should have_selector("form[method='post'][action='#{admin_product_path(product)}']")
    end
  end

end