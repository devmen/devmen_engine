class Admin::ContactUs::EntriesController < Admin::BaseController
  inherit_resources
  defaults resource_class: ::ContactUs::Entry, collection_name: "contacts_us", instance_name: "contact_us"

  def collection_path
    admin_contact_us_entry_index_path
  end

  def destroy
    destroy! { collection_path }
  end
end
