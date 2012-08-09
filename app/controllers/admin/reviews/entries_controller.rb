class Admin::Reviews::EntriesController < Admin::BaseController
  inherit_resources
  defaults resource_class: ::Review::Entry, collection_name: "reviews", instance_name: "review"

  def collection_path
    admin_reviews_path
  end

  def destroy
    destroy! { collection_path }
  end

  def visible
    visible = params[:type] == "on"
    resource.update_column :visible, visible
    redirect_to :back
  end
end
