require 'spec_helper'

describe 'Static pages' do
  let(:test_page) { FactoryGirl.create(:page) }
  
  it "visit the right page" do
    visit '/' + test_page.url    
    page.should have_selector("head title", :text => test_page.name)    
    page.should have_content(test_page.body)
    current_path.should == '/' + test_page.url
  end
  
  it "visit the failure page" do
    visit '/' + random_url
    page.should have_content("The page you were looking for doesn't exist.")    
  end  

end
