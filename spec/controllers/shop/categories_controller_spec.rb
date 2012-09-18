require 'spec_helper'

describe Shop::CategoriesController do

  describe "GET index" do
    it "populates an array of categories" do
      category = create(:product_category)
      get :index
      assigns(:categories).should eq([category])
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET show" do
    it "assigns the requested category as @category" do
      category = create(:product_category)
      get :show, id: category
      assigns(:category).should eq(category)
    end

    it "assigns products related to the category as @products" do
      category = create(:product_category)
      product = create(:product, category_id: category.id)
      get :show, id: category
      assigns(:products).should eq([product])
    end

    it "renders the :show view" do
      category = create(:product_category)
      get :show, id: category
      response.should render_template :show
    end
  end

end
