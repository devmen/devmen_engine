class Admin::PagesController < ApplicationController
	def show
		@page = Page.find(params[:id])
		@title = @page.name
	end

	def new
		@page = Page.new
		@title = "New page"
	end

	def create
		@page = Page.new(params[:page])
		@page.url = transliterate(@page.name).parameterize if @page.url.blank?
		if @page.save
		else
		end
	end

	def edit
		@page = Page.find(params[:id])
		@title = @page.name		
	end

	def update
		@page = Page.find(params[:id])
		@page.url = transliterate(@page.name).parameterize if @page.url.blank?
		if @page.update_attributes(params[:page])     
    else
    end
	end

	def destroy
		@page = Page.find(params[:id])
		@page.destroy
	end

end
