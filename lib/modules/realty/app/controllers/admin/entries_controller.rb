class Admin::Realty::EntriesController < Admin::BaseController
  inherit_resources
  defaults :resource_class => ::Realty::Entry, :collection_name => 'realty', :instance_name => 'realty_entry'

  def collection_path
    admin_realty_path
  end

  def create
    create!{ collection_path }
  end

  def update
    update!{ collection_path }
  end

  def destroy
    destroy!{ collection_path }
  end

end