require 'spec_helper'

describe "User sessions" do

  describe "sign in/out" do

    describe "failure" do

      it "should not sign a user in" do
        visit signin_path
        fill_in "user_session[name]",    :with => ""
        fill_in "user_session[password]", :with => ""
        click_button 'user_session_submit'
        current_url.should == signin_url
        page.has_selector?("#messages", text: 'error')
        page.has_selector?("form#new_user_session")
      end
    end

    describe "success" do
      let(:user) { FactoryGirl.create(:user) }

      it "should sign a user in and out" do
        visit signin_path
        fill_in "user_session[name]", :with => user.name
        fill_in "user_session[password]", :with => user.password
        # click_button 'user_session_submit'
        click_button "Sign in"
        current_url.should == root_url
        # save_and_open_page
        # controller.should be_signed_in
        page.has_selector?("#messages", text: 'success')
        page.should have_content('Sign out')
        click_on "Sign out"
        # controller.should_not be_signed_in
        current_url.should == root_url
        page.should have_content('Sign in')
      end
    end
  end
end
