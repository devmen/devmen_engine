require 'spec_helper'

describe UserSessionsController do
  render_views  

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end

    it "should have the signin form" do
      get :new
      response.body.should have_selector("form#new_user_session")
    end

    it "should have a name field" do
      get :new
      response.body.should have_selector("input[name='user_session[name]'][type='text']")
    end

    it "should have a password field" do
      get :new
      response.body.should have_selector("input[name='user_session[password]'][type='password']")
    end
  end

  describe "POST 'create'" do
    
    describe "invalid sign in" do
      
      before(:each) do
        @attr = { :name => 'invalid', :email => "email@devmen.com", :password => "invalid" }
      end

      it "should redirect to the sign in page" do
        post :create, :user_session => @attr
        flash[:error].should_not be_nil
        response.should redirect_to(signin_path)
      end      
    end

    describe "with valid email and password" do
      
      before(:each) do        
        @user = FactoryGirl.create(:user)
        @attr = { :name => @user.name, :email => @user.email, :password => @user.password }
        # stubbed cause authlogic
        controller.stub(:current_user).and_return(@user)
      end

      it "should sign the user in" do
        post :create, :user_session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to the root_url" do
        post :create, :user_session => @attr
        flash[:success].should_not be_nil
        response.should redirect_to(root_url)
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    before(:each) do        
      @user = FactoryGirl.create(:user)      
      post :create, :user_session => { :name => @user.name, :email => @user.email, :password => @user.password }
    end

    it "should sign a user out" do      
      delete :destroy
      controller.should_not be_signed_in
      flash[:success].should_not be_nil
      response.should redirect_to(root_path)      
    end
  end

end
