require 'spec_helper'

describe 'Shop::Categories' do
  subject { page }

  describe "list of category" do
    let(:root_categories) { create_list(:product_category, 2) }
    let(:sub_categories) { create_list(:product_category, 2, parent_id: root_categories[0].id) }
    let(:categories) { root_categories + sub_categories }
    before do
      categories
      visit product_categories_path
    end

    it "should contain link for each category" do
      categories.each do |category|
        should have_selector("a[href='#{product_category_path(category)}']", text: category.name)
      end
    end
  end

  describe "category page" do
    let(:category) { create(:product_category) }
    let(:sub_categories) { create_list(:product_category, 2, parent_id: category.id) }
    before do
      category
      sub_categories
      visit product_category_path(category)
    end

    it "should contain link for each subcategory" do
      sub_categories.each do |sub_category|
        should have_selector("a[href='#{product_category_path(sub_category)}']", text: sub_category.name)
      end
    end

    it_behaves_like "a list of product" do
      let(:products) { create_list(:product, 2, category: category) + create_list(:product, 2, category: sub_categories[0]) }
      let(:product_with_pictures) { create_list(:product_with_pictures, 2, category: category) }
      let(:products_path) { product_category_path(category) }
    end
  end

end