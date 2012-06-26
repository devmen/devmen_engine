class Admin::News::EntriesController < Admin::BaseController
  inherit_resources
  defaults :resource_class => ::News::Entry, :collection_name => 'news', :instance_name => 'news_entry'

  def collection_path
    admin_news_path
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