require 'spec_helper'

describe "Administrate users", :js => true do

  before(:each) do
    @admin = login_as_admin
    @user = FactoryGirl.create(:user)
    visit admin_path
  end

  it "should have the right links on the layout" do
    page.should have_selector("a[href='#{admin_users_path}']")
    page.should have_selector("a[href='#{new_admin_user_path}']")
    page.should have_selector("a[href='#{edit_admin_user_path(@admin)}']")
    page.should have_selector("a[href='#{signout_path}'][data-method='delete']")
  end

  it "should should show user list" do
    find("a[href='#{admin_users_path}']").click
    within "#content-container" do
      page.should have_selector("a[href='#{new_admin_user_path}']")
      page.should have_selector("a[href='#{admin_user_path(@admin)}']")
      page.should have_selector("a[href='#{edit_admin_user_path(@admin)}']")
      page.should have_selector("a[href='#{admin_user_path(@admin)}'][data-method='delete']")
      page.should have_selector("a[href='#{admin_user_path(@user)}']")
      page.should have_selector("a[href='#{edit_admin_user_path(@user)}']")
      page.should have_selector("a[href='#{admin_user_path(@user)}'][data-method='delete']")
    end
  end

  describe "new user" do

    before(:each) do
      @form_selector = 'form#new_user'
      find("a[href='#{new_admin_user_path}']").click
    end

    it "should have form" do
      page.should have_selector(@form_selector)
      within(@form_selector) do
        has_selector?('input[name="user[name]"]')
        has_selector?('input[name="user[email]"]')
        has_selector?('input[name="user[password]"]')
        has_selector?('input[name="user[roles][]"][value="admin"]')
        has_selector?('input[name="user[roles][]"][value="manager"]')
      end
    end

    describe "submit form" do

      describe "failure" do

        it "should not create a new user" do
          user_count = User.count
          within(@form_selector) do
            fill_in 'user[name]', :with => ""
            fill_in 'user[email]', :with => "invalid.email"
            fill_in 'user[password]', :with => "123"
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          User.count.should == user_count
          page.should have_selector(@form_selector)
        end
      end

      describe "success" do

        before(:each) do
          @new_manager = FactoryGirl.build(:manager)
        end

        it "should create a new user" do
          user_count = User.count
          within(@form_selector) do
            fill_in 'user[name]', :with => @new_manager.name
            fill_in 'user[email]', :with => @new_manager.email
            fill_in 'user[password]', :with => @new_manager.password
            # find('input[name="user[roles][]"][value="manager"]').check
            check "Manager"
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          User.count.should == user_count + 1
          User.find_by_name(@new_manager.name).role?(:manager).should be_true
        end
      end
    end
  end

  describe "edit user" do

    before(:each) do
      @manager = FactoryGirl.create(:manager)
      @form_selector = 'form#edit_user_' + @manager.id.to_s
      visit admin_users_path
      find("a[href='#{edit_admin_user_path(@manager)}']").click
    end

    it "should have form" do
      page.should have_selector(@form_selector)
      within(@form_selector) do
        find_field('user[name]').value.should == @manager.name
        find_field('user[email]').value.should == @manager.email
        find('input[name="user[roles][]"][value="manager"]').checked?
      end
    end

    describe "submit form" do

      describe "failure" do

        it "should not update the user" do
          within(@form_selector) do
            fill_in 'user[email]', :with => "invalid.email"
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          page.should have_selector(@form_selector)
        end
      end

      describe "success" do

        it "should update the user" do
          exist_manager = User.find_by_name @manager.name
          new_name = @manager.name + ' 123'
          within(@form_selector) do
            fill_in 'user[name]', :with => new_name
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          exist_manager.reload
          exist_manager.name.should == new_name
        end
      end
    end
  end

  describe "remove user" do

    before(:each) do
      @manager = FactoryGirl.create(:manager)
      visit admin_users_path
    end

    it "should be success" do
      user_count = User.count
      handle_js_confirm do
        find("a[href='#{admin_user_path(@manager)}'][data-method='delete']").click
      end
      wait_until { find("#messages", visible: true) }
      User.count.should == user_count - 1
    end
  end

end