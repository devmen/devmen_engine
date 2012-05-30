class Admin::PagesController < Admin::BaseController
	inherit_resources
	actions :all, :exept => [:index]
	respond_to :html, :js
  
  def new
    new! do |format|
      format.js { render 'admin/pages/tpl.js.erb' }
    end
  end

  def show
    show! do |format|
      format.js { render 'admin/pages/tpl.js.erb' }
    end
  end

  def edit
    edit! do |format|
      format.js { render 'admin/pages/tpl.js.erb' }
    end
  end

  # protected

  #   def resource
  #     @page ||= end_of_association_chain.find_by_url(params[:id])
  #   end

end
