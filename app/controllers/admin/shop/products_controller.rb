class Admin::Shop::ProductsController < ApplicationController
  inherit_resources
  defaults resource_class: ::Shop::Product, collection_name: "products", instance_name: "product"

  def create
    create! { collection_path }
  end

  def update
    update! { collection_path }
  end

  def destroy
    destroy! { collection_path }
  end

  private

    def collection_path
      admin_products_path
    end
end
