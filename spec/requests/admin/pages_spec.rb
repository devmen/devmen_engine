require 'spec_helper'

describe "Administrate pages", :js => true do

  before(:each) do
    login_as_admin
    @first_page = FactoryGirl.create(:page)
    @second_page = FactoryGirl.create(:page)
    visit admin_path
  end

  it "should have the right links on the layout" do
    page.should have_selector("a[href='#{new_admin_page_path}']")
    page.should have_selector("a[href='#{admin_page_path(@first_page)}']")
    page.should have_selector("a[href='#{edit_admin_page_path(@first_page)}']")
    page.should have_selector("a[href='#{admin_page_path(@first_page)}'][data-method='delete']")
    page.should have_selector("a[href='#{admin_page_path(@second_page)}']")
    page.should have_selector("a[href='#{edit_admin_page_path(@second_page)}']")
    page.should have_selector("a[href='#{admin_page_path(@second_page)}'][data-method='delete']")
  end

  it "should should show page" do
    find("a[href='#{admin_page_path(@first_page)}']").click
    page.should have_content(@first_page.body)
    page.should have_selector(".current a[href='#{admin_page_path(@first_page)}']")
    page.evaluate_script("window.location.pathname").should == admin_page_path(@first_page)

    find("a[href='#{admin_page_path(@second_page)}']").click
    page.should have_content(@second_page.body)
    page.should have_selector(".current a[href='#{admin_page_path(@second_page)}']")
    page.evaluate_script("window.location.pathname").should == admin_page_path(@second_page)
  end

  describe "new page" do

    before(:each) do
      find("a[href='#{new_admin_page_path}']").click
    end

    it "should have form" do
      page.should have_selector('form#new_page')
      within('form#new_page') do
        has_selector?('input[name="page[name]"]')
        has_selector?('input[name="page[url]"]')
        has_selector?('textarea[name="page[body]"]')
      end
    end

    it "should have editor" do
      find('form#new_page').should have_selector('textarea[name="page[body]"].markItUpEditor')
    end

    describe "submit form" do

      describe "failure" do

        it "should not create a new page" do
          page_count = Page.count
          within('form#new_page') do
            fill_in 'page[name]', :with => ""
            fill_in 'page[url]', :with => "invalid.url"
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          page.should have_selector('form#new_page')
          find('form#new_page').should have_selector('textarea[name="page[body]"].markItUpEditor')
          Page.count.should == page_count
        end
      end

      describe "success" do

        before(:each) do
          @new_page = FactoryGirl.build(:page)
        end

        it "should create a new page" do
          page_count = Page.count
          within('form#new_page') do
            fill_in 'page[name]', :with => @new_page.name
            fill_in 'page[url]', :with => @new_page.url
            fill_in 'page[body]', :with => @new_page.body
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          Page.count.should == page_count + 1
          page.should have_selector("a[href='#{admin_page_path(@new_page)}']")
          page.should have_content(@new_page.body)
        end

        it "should create a new page and autofill url" do
          page_count = Page.count
          within('form#new_page') do
            fill_in 'page[name]', :with => @new_page.name
            fill_in 'page[url]', :with => ''
            fill_in 'page[body]', :with => @new_page.body
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          Page.count.should == page_count + 1
          page.should have_selector("a[href='#{admin_pages_path + '/' + @new_page.name.parameterize}']")
          page.should have_content(@new_page.body)
        end
      end
    end
  end

  describe "edit page" do

    before(:each) do
      @form_selector = 'form#edit_page_' + @first_page.id.to_s
      link = find("a[href='#{edit_admin_page_path(@first_page)}']")
      # If use Selenium driver, action links should be shown
      # page.execute_script("$(\"a[href='#{edit_admin_page_path(@first_page)}']\").parent().trigger('mouseenter')")
      # page.wait_until { link.visible? }
      # For Webkit driver
      link.click
    end

    it "should have form" do
      page.should have_selector(@form_selector)
      within(@form_selector) do
        find_field('page[name]').value.should == @first_page.name
        find_field('page[url]').value.should == @first_page.url
        find_field('page[body]').value.should == @first_page.body
      end
    end

    it "should have editor" do
      find(@form_selector).should have_selector('textarea[name="page[body]"].markItUpEditor')
    end

    describe "submit form" do

      describe "failure" do

        it "should not update the page" do
          within(@form_selector) do
            fill_in 'page[name]', :with => ""
            fill_in 'page[url]', :with => "invalid.url"
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          page.should have_selector(@form_selector)
          find(@form_selector).should have_selector('textarea[name="page[body]"].markItUpEditor')
          within(@form_selector) do
            find_field('page[body]').value.should == @first_page.body
          end
        end
      end

      describe "success" do

        before(:each) do
          @new_page_attrs = FactoryGirl.attributes_for(:page)
        end

        it "should update the page" do
          within(@form_selector) do
            fill_in 'page[name]', :with => @new_page_attrs[:name]
            fill_in 'page[url]', :with => @new_page_attrs[:url]
            fill_in 'page[body]', :with => @new_page_attrs[:body]
            find('input[type="submit"]').click
          end
          wait_until { find("#messages", visible: true) }
          page.should have_selector("a[href='#{admin_page_path(@new_page_attrs[:url])}']")
          page.should have_content(@new_page_attrs[:body])
        end
      end
    end
  end

  describe "remove page" do

    it "should be success" do
      page_count = Page.count
      # For Selenium driver
      # find("a[href='#{admin_page_path(@first_page)}']").click
      # page.driver.browser.switch_to.alert.accept
      # For Webkit driver
      handle_js_confirm do
        find("a[href='#{admin_page_path(@first_page)}'][data-method='delete']").click
      end
      wait_until { find("#messages", visible: true) }
      Page.count.should == page_count - 1
      page.should_not have_selector("a[href='#{admin_page_path(@first_page)}']")
    end

    it "should show another page" do
      visit admin_page_path(@first_page)
      # For Selenium driver
      # find("a[href='#{admin_page_path(@first_page)}']").click
      # page.driver.browser.switch_to.alert.accept
      # For Webkit driver
      handle_js_confirm do
        find("a[href='#{admin_page_path(@first_page)}'][data-method='delete']").click
      end
      wait_until { find("#messages", visible: true) }
      page.evaluate_script("window.location.pathname").should == admin_page_path(@second_page)
      page.should have_content(@second_page.body)
    end
  end

end
