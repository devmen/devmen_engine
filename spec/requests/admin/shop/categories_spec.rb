require 'spec_helper'

describe 'Shop::Categories', js: true do
  before { login_as_admin }
  subject { page }

  describe "list of category" do
    let(:root_categories) { create_list(:product_category, 2) }
    let(:sub_categories) { create_list(:product_category, 2, parent_id: root_categories[0].id) }
    let(:categories) { root_categories + sub_categories }
    before do
      categories
      visit admin_product_categories_path
    end

    it "should contain add button and links for each category" do
      should have_selector("a[href='#{new_admin_product_category_path}']")
      categories.each do |category|
        should have_selector("a[href='#{admin_product_category_path(category)}']", text: category.name)
        should have_selector("a[href='#{edit_admin_product_category_path(category)}']")
        should have_selector("a[href='#{admin_product_category_path(category)}'][data-method='delete']")
      end
    end

    it "should delete a category and all descendants" do
      category = root_categories[0]
      expect {
        handle_js_confirm do
          find("a[href='#{admin_product_category_path(category)}'][data-method='delete']").click
        end
        wait_until { find("#messages", visible: true) }
      }.to change(Shop::Category, :count).by(-3)
      within "#messages" do
        should have_selector('.alert-success')
      end
      ([category] + sub_categories).each do |category|
        should_not have_selector("a[href='#{admin_product_category_path(category)}']")
      end
    end

  end

  describe "category page" do
    let(:category) { create(:product_category) }
    before do
      visit admin_product_category_path(category)
    end

    it "should contain category name, description, edit and delete buttons" do
      should have_content(category.name)
      should have_content(category.description)
      should have_selector("a[href='#{edit_admin_product_category_path(category)}']")
      should have_selector("a[href='#{admin_product_category_path(category)}'][data-method='delete']")
    end
  end

  describe "new category page" do
    let(:parent_category) { create(:product_category) }
    before do
      parent_category
      visit new_admin_product_category_path
    end

    it "should contain category form" do
      within "form[method='post'][action='#{admin_product_categories_path}']" do
        should have_field("shop_category[name]")
        should have_field("shop_category[description]")
        should have_field("shop_category[parent_id]")
        should have_button(:submit)
        should have_link(:back)
      end
    end

    it "should create new category" do
      attrs = attributes_for(:product_category)
      expect {
        fill_in "shop_category[name]", with: attrs[:name]
        fill_in "shop_category[description]", with: attrs[:description]
        find_button(:submit).click
        wait_until { find("#messages", visible: true) }
      }.to change(Shop::Category, :count).by(1)
      within "#messages" do
        should have_selector('.alert-success')
      end
    end

    it "should not create new category" do
      expect {
        find_button(:submit).click
        wait_until { find("#messages", visible: true) }
      }.to_not change(Shop::Category, :count)
      within "#messages" do
        should have_selector('.alert-error')
      end
    end

    it "should create new subcategory" do
      attrs = attributes_for(:product_category)
      expect {
        fill_in "shop_category[name]", with: attrs[:name]
        fill_in "shop_category[description]", with: attrs[:description]
        select parent_category.name, from: "shop_category[parent_id]"
        find_button(:submit).click
        wait_until { find("#messages", visible: true) }
      }.to change(Shop::Category, :count).by(1)
      visit admin_product_categories_path
      within "#category-#{parent_category.id}" do
        parent_category.reload
        category = parent_category.descendants[0]
        should have_selector("#category-#{category.id}")
      end
    end
  end

  describe "edit category page" do
    let(:category) { create(:product_category) }
    before do
      visit edit_admin_product_category_path(category)
    end

    it "should contain category form" do
      within "form[method='post'][action='#{admin_product_category_path(category)}']" do
        should have_field("shop_category[name]")
        should have_field("shop_category[description]")
        should have_field("shop_category[parent_id]")
        should have_button(:submit)
        should have_link(:back)
      end
    end

    it "should update the category" do
      attrs = attributes_for(:product_category)
      fill_in "shop_category[name]", with: attrs[:name]
      fill_in "shop_category[description]", with: attrs[:description]
      find_button(:submit).click
      wait_until { find("#messages", visible: true) }
      within "#messages" do
        should have_selector('.alert-success')
      end
      visit edit_admin_product_category_path(category)
      should have_field("shop_category[name]", value: attrs[:name])
      should have_field("shop_category[description]", value: attrs[:description])
    end

    it "should not update the category" do
      fill_in "shop_category[name]", with: ""
      find_button(:submit).click
      wait_until { find("#messages", visible: true) }
      within "#messages" do
        should have_selector('.alert-error')
      end
      should have_selector("form[method='post'][action='#{admin_product_category_path(category)}']")
    end
  end

end