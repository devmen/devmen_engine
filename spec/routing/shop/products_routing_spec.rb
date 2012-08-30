require "spec_helper"

describe Shop::ProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/shop/products").should route_to("shop/products#index")
    end

    it "routes to #new" do
      get("/shop/products/new").should route_to("shop/products#new")
    end

    it "routes to #show" do
      get("/shop/products/1").should route_to("shop/products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/shop/products/1/edit").should route_to("shop/products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/shop/products").should route_to("shop/products#create")
    end

    it "routes to #update" do
      put("/shop/products/1").should route_to("shop/products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/shop/products/1").should route_to("shop/products#destroy", :id => "1")
    end

  end
end
