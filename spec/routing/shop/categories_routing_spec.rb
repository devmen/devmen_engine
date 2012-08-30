require "spec_helper"

describe Shop::CategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/shop/categories").should route_to("shop/categories#index")
    end

    it "routes to #new" do
      get("/shop/categories/new").should route_to("shop/categories#new")
    end

    it "routes to #show" do
      get("/shop/categories/1").should route_to("shop/categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/shop/categories/1/edit").should route_to("shop/categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/shop/categories").should route_to("shop/categories#create")
    end

    it "routes to #update" do
      put("/shop/categories/1").should route_to("shop/categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/shop/categories/1").should route_to("shop/categories#destroy", :id => "1")
    end

  end
end
