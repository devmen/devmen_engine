require 'spec_helper'

describe Sitemap::EntriesController do
  describe "GET #index" do
    let!(:page1) { create(:page) }
    let!(:page2) { create(:page) }
    let!(:news_entry1) { create(:news_entry) }
    let!(:news_entry2) { create(:news_entry) }
    let!(:realty1) { create(:realty) }
    let!(:realty2) { create(:realty) }

    before do
      get :index
    end

    it "populates an array of pages" do
      assigns(:pages).should == [page1, page2]
    end

    it "populates an array of news" do
      assigns(:news).should == [news_entry2, news_entry1]
    end

    it "populates an array of realties" do
      assigns(:realties).should == [realty2, realty1]
    end

    it "renders the :index view" do
      response.should render_template :index
    end
  end
end
