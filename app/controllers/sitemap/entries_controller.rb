class Sitemap::EntriesController < ApplicationController
  def index
    @pages = Page.all
    @news = News::Entry.all if News.present?
    @realties = Realty::Entry.all if Realty.present?
  end
end
