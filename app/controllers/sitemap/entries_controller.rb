class Sitemap::EntriesController < ApplicationController
  caches_action :index, expires_in: 4.hours

  def index
    @pages = Page.all
    @news_categories = News::Category.order(:name) if News.present?
    @realty_categories = Realty::Category.order(:name) if Realty.present?
    if Shop.present?
      @product_categories = Shop::Category.order(:name)
      @products = Shop::Product.includes(:pictures)
    end
  end
end
