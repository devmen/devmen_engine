require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    let(:test_page) { FactoryGirl.create(:page) }
        
    it "should return the right page" do
      get :show, :page => test_page.url
      response.should be_success
      response.body.should have_selector("head title", :text => test_page.name)
      response.body.should have_content(test_page.body)      
    end

    it "should return 404 for the random page" do
      get :show, :page => random_url
      response.status.should == 404
    end
  end

end
