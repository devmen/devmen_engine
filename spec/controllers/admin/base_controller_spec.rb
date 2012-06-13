require 'spec_helper'

describe Admin::BaseController do

  describe "for non-admin users" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)      
      controller.stub(:current_user).and_return(@user)
    end

    it_should_require_admin_role_for_actions :index
  end

  describe "for admin users" do
    # test only customized actions, don't test InheritResources

    before(:each) do
      @admin = FactoryGirl.create(:admin)
      controller.stub(:current_user).and_return(@admin)
    end
    
    describe "GET 'index'" do
      it "should render 'new' and js 'tpl' template" do
        get :index
        response.should be_success        
      end      
    end
  end

end
