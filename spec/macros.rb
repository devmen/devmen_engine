module Macros

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def it_should_require_admin_role_for_actions(*actions)
      actions.each do |action|
        it "#{action} action should require admin role" do
          get action, :id => 1
          flash[:notice].should_not be_nil
          response.should redirect_to(signin_path)
        end
      end
    end
  end

  def random_url
    rand(16**20).to_s(16)
  end

  def login_as_admin
    admin = FactoryGirl.create(:admin)
    visit signin_path
    fill_in "user_session[name]", :with => admin.name
    fill_in "user_session[password]", :with => admin.password        
    click_button 'user_session_submit'
    admin
  end

  def handle_js_confirm(accept=true)
    page.execute_script "window.original_confirm_function = window.confirm"
    page.execute_script "window.confirmMsg = null"
    page.execute_script "window.confirm = function(msg) { window.confirmMsg = msg; return #{!!accept}; }"
    yield
  ensure
    page.execute_script "window.confirm = window.original_confirm_function"
  end

  def get_confirm_text
    page.evaluate_script "window.confirmMsg"
  end
end