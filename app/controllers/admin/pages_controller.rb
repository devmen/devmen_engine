class Admin::PagesController < Admin::BaseController
	inherit_resources
	actions :all, :exept => [:index]
	
end
