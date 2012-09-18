require 'spec_helper'

describe Shop::ProductsController do

  describe "GET index" do
    it "populates an array of products" do
      product = create(:product)
      get :index
      assigns(:products).should eq([product])
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET show" do
    it "assigns the requested product as @product" do
      product = create(:product)
      get :show, id: product
      assigns(:product).should eq(product)
    end

    it "renders the :show view" do
      product = create(:product)
      get :show, id: product
      response.should render_template :show
    end

    it "redirects to actual product url" do
      product = create(:product)
      legacy_slug = product.slug
      product.update_attributes(name: Faker::Lorem.sentence(2), slug: '')
      product.reload
      get :show, id: legacy_slug
      response.should redirect_to product_path(product)
    end
  end

end
