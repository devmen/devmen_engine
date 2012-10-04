class Admin::PagesController < Admin::BaseController
	inherit_resources
	actions :all, :exept => [:index]
	respond_to :html, :js

  load_and_authorize_resource

  def new
    new! do |format|
      format.js { render js_tpl }
    end
  end

  def create
    create! do |success, failure|
      success.js do
        @template = "show"
        render js_tpl
      end
      failure.js do
        @template = "new"
        render js_tpl
      end
    end
  end

  def show
    @page = new_page if resource.nil?
    show! do |format|
      format.html { render :new if resource.new_record? }
      format.js do
        @template = "new" if resource.new_record?
        render js_tpl
      end
    end
  end

  def edit
    @page = new_page if resource.nil?
    edit! do |format|
      format.html { render :new if resource.new_record? }
      format.js do
        @template = "new" if resource.new_record?
        render js_tpl
      end
    end
  end

  def update
    update! do |success, failure|
      success.js do
        @template = "show"
        render js_tpl
      end
      failure.js do
        @template = "edit"
        render js_tpl
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.js do
        # Change page if this is a current
        if request.referer == request.url
          @page = Page.first() || Page.new
          @template = !@page.new_record? ? "show" : "new"
        end
        render js_tpl
      end
      failure.js do
        render js_tpl
      end
    end
  end

  protected

    def resource
      if Page.url?(params[:id])
        @page ||= end_of_association_chain.find_by_url(params[:id])
      end
    end

  private

    # Return js template for render, inside render @template html and necessary javascript
    def js_tpl
      h = { :template => 'admin/pages/tpl', :format => :js, :handler => :erb }
    end

    # Return new page object
    def new_page
      page = Page.new
      page.url = params[:id] if Page.url?(params[:id]) && params[:id] != 'new-page'
      page
    end

end
