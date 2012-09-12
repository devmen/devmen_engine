class Admin::Shop::ProductsController < Admin::BaseController
  inherit_resources
  defaults resource_class: ::Shop::Product, collection_name: "products", instance_name: "product"

  has_scope :by_category

  def new
    new! {
      build_new_picture_records
    }
  end

  def create
    create! do |success, failure|
      success.html { redirect_to collection_path }
      failure.html do
        build_new_picture_records
        render :new
      end
    end
  end

  def edit
    edit! {
      3.times { resource.pictures.build }
    }
  end

  def update
    update! do |success, failure|
      success.html { redirect_to collection_path }
      failure.html do
        build_new_picture_records
        render :edit
      end
    end
  end

  def destroy
    destroy! { collection_path }
  end

  private

    def collection
      @products ||= end_of_association_chain.includes(:pictures)
    end

    def collection_path
      admin_products_path
    end

    def build_new_picture_records
      3.times { resource.pictures.build }
    end
end
