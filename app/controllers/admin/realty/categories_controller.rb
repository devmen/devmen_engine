class Admin::Realty::CategoriesController < Admin::BaseController
  inherit_resources
  defaults resource_class: ::Realty::Category, collection_name: "categories", instance_name: "category"

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
    admin_realty_categories_path
  end
end
