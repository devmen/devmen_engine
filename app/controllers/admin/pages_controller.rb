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
    show! do |format|
      format.js { render js_tpl }
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
        @page = Page.first()
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
        @page = Page.new if params[:id] == 'new-page'
        @page ||= end_of_association_chain.find_by_url(params[:id])        
      end
    end

  private

    def js_tpl
      h = { :template => 'admin/pages/tpl', :format => :js, :handler => :erb }
    end

end
