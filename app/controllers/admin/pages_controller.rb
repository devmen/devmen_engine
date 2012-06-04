class Admin::PagesController < Admin::BaseController
	inherit_resources
	actions :all, :exept => [:index]
	respond_to :html, :js  

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
    if resource.nil?
      @page = Page.new
      @page.url = params[:id] unless params[:id] == 'new-page'          
    end
    show! do |format|
      format.html { render :new if resource.new_record? }
      format.js do
        @template = "new" if resource.new_record?
        render js_tpl
      end
    end
  end

  def edit
    edit! do |format|
      format.js { render js_tpl }
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
        @page = Page.first() || Page.new
        @template = "show"      
        render js_tpl
      end
      failure.js do        
        @template = "show"      
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

end
