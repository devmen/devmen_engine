require 'spec_helper'

describe Admin::PagesController do
  render_views

  describe "for non-admin users" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)      
      controller.stub(:current_user).and_return(@user)
    end

    it_should_require_admin_role_for_actions :new, :create, :show, :edit, :update, :destroy
  end

  describe "for admin users" do
    # test only customized actions, don't test InheritResources

    before(:each) do
      @admin = FactoryGirl.create(:admin)
      controller.stub(:current_user).and_return(@admin)
    end
    let(:valid_page_attrs) { FactoryGirl.attributes_for(:page) }
    let(:invalid_page_attrs) { FactoryGirl.attributes_for(:page, name: '', url: 'test,page') }
    let(:existing_page) { FactoryGirl.create(:page) }    

    describe "GET 'new'" do
      it "should render 'new' and js 'tpl' template" do
        xhr :get, :new
        response.should be_success
        response.should render_template(:new)
        response.should render_template(:tpl)        
      end      
    end

    describe "POST 'create'" do
      
      describe "with invalid page fields" do
        
        it "should not create a page" do
          lambda do
            xhr :post, :create, :page => invalid_page_attrs
          end.should_not change(Page, :count)
        end

        it "should re-render 'new' and js 'tpl' template" do
          xhr :post, :create, :page => invalid_page_attrs
          flash[:error].should_not be_nil
          response.should render_template(:new)
          response.should render_template(:tpl)
        end 
      end

      describe "with valid page fields" do
        
        it "should create a page" do
          lambda do
            xhr :post, :create, :page => valid_page_attrs
          end.should change(Page, :count).by(1)
        end

        it "should render 'show' and js 'tpl' template for a new page" do
          xhr :post, :create, :page => valid_page_attrs
          flash[:success].should_not be_nil
          response.should render_template(:show)
          response.should render_template(:tpl)
        end
      end
    end

    describe "GET 'edit'" do

      describe "existing page" do

        it "should render 'edit' and js 'tpl' template" do
          xhr :get, :edit, :id => existing_page.url
          response.should be_success
          response.should render_template(:edit)
          response.should render_template(:tpl)          
        end
      end

      describe "not existing page" do

        it "should render 'new' and js 'tpl' template" do
          xhr :get, :edit, :id => random_url
          response.should be_success
          response.should render_template(:new)
          response.should render_template(:tpl)          
        end
      end
    end

    describe "GET 'show'" do

      describe "existing page" do

        it "should render 'show' and js 'tpl' template" do
          xhr :get, :show, :id => existing_page.url
          response.should be_success
          response.should render_template(:show)
          response.should render_template(:tpl)          
        end
      end

      describe "not existing page" do

        it "should render 'new' and js 'tpl' template" do
          xhr :get, :show, :id => random_url
          response.should be_success
          response.should render_template(:new)
          response.should render_template(:tpl)          
        end
      end
    end

    describe "PUT 'update'" do
      
      describe "with invalid page fields" do
        
        it "should not change page attributes" do
          xhr :put, :update, :id => existing_page.url, :page => invalid_page_attrs
          attrs = { name: existing_page.name, url: existing_page.url }
          existing_page.reload
          existing_page.name.should  == attrs[:name]
          existing_page.url.should == attrs[:url]
        end

        it "should re-render 'edit' and js 'tpl' template" do
          xhr :put, :update, :id => existing_page.url, :page => invalid_page_attrs
          flash[:error].should_not be_nil
          response.should be_success
          response.should render_template(:edit)
          response.should render_template(:tpl)
        end 
      end

      describe "with valid page fields" do
        
        it "should not change page attributes" do
          xhr :put, :update, :id => existing_page.url, :page => valid_page_attrs          
          existing_page.reload
          existing_page.name.should  == valid_page_attrs[:name]
          existing_page.url.should == valid_page_attrs[:url]
        end

        it "should render 'show' and js 'tpl' template for a new page" do
          xhr :put, :update, :id => existing_page.url, :page => valid_page_attrs
          flash[:success].should_not be_nil
          response.should be_success
          response.should render_template(:show)
          response.should render_template(:tpl)
        end
      end
    end
    
    describe "DELETE 'destroy'" do

      describe "existing page" do

        before(:each) do
          existing_page
        end

        it "should destroy the page" do
          lambda do
            xhr :delete, :destroy, :id => existing_page.url
          end.should change(Page, :count).by(-1)
        end

        describe "when one page exists" do

          it "should render only js 'tpl' template" do            
            xhr :delete, :destroy, :id => existing_page.url          
            flash[:success].should_not be_nil
            response.should be_success            
            response.should render_template(:tpl)          
          end

          it "should render 'new' and js 'tpl' template" do            
            request.env["HTTP_REFERER"] = admin_pages_url + '/' + existing_page.url             
            xhr :delete, :destroy, :id => existing_page.url
            flash[:success].should_not be_nil
            response.should be_success
            response.should render_template(:new)
            response.should render_template(:tpl)          
          end
        end

        describe "when at least two pages exist" do
          before(:each) do
            FactoryGirl.create(:page, name: 'Another page', url: random_url )
          end

          it "should render 'show' and js 'tpl' template" do
            request.env["HTTP_REFERER"] = admin_pages_url + '/' + existing_page.url            
            xhr :delete, :destroy, :id => existing_page.url       
            response.should be_success
            response.should render_template(:show)
            response.should render_template(:tpl)          
          end
        end
      end

      # describe "not existing page" do

      #   it "should not destroy the page" do
      #     lambda do
      #       xhr :delete, :destroy, :id => random_url
      #     end.should_not change(Page, :count)
      #   end

      #   it "should render js 'tpl' template" do
      #     xhr :delete, :destroy, :id => random_url
      #     response.should be_success
      #     response.should render_template(:tpl)          
      #   end
      # end
    end
  end

end