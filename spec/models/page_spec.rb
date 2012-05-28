require 'spec_helper'

describe Page do
  before(:each) do
    @attr = { :name => "Test Page", :url => "test_page" }
  end

  it "should create a new instance given valid attributes" do
    Page.create!(@attr)
  end

  it "should require a name" do
  	page = Page.new(@attr.merge(:name => ""))
    page.should be_invalid
  end

  it "should require an url" do
  	page = Page.new(@attr.merge(:url => ""))
    page.should be_invalid
  end

  it "should reject names that are too long" do
    long_name = "a" * 101
    page = Page.new(@attr.merge(:name => long_name))
    page.should be_invalid
  end

  it "should accept valid url" do
    urls = %w[test_page TEST-page test_page-123]
    urls.each do |url|
      page = Page.new(@attr.merge(:url => url))
      page.should be_valid
    end
  end

  it "should reject invalid url" do
    urls = %w[test,page test@page test_page.123]
    urls.each do |url|
      page = Page.new(@attr.merge(:url => url))
      page.should be_invalid
    end
  end

  it "should reject duplicate urls" do
    Page.create!(@attr)
    page = Page.new(@attr)
    page.should be_invalid
  end

  it "should reject urls identical up to case" do
    upcased_url = @attr[:url].upcase
    Page.create!(@attr.merge(:url => upcased_url))
    page = Page.new(@attr)
    page.should be_invalid
  end
end
