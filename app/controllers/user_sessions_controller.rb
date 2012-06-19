class UserSessionsController < ApplicationController
  # before_filter :require_no_user, :only => [:new, :create]
  # before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = I18n.t 'user_sessions.flash.signin', :default => "Successfully signed in.", :user_name => current_user.name
      redirect_to user_session_start_url
    else
      flash[:error] = I18n.t 'user_sessions.flash.credentials_error', :default => "Invalid email/password combination."
      redirect_to signin_path
    end
  end
  
  def destroy
    user_name = current_user.name
    current_user_session.destroy    
    flash[:success] = I18n.t 'user_sessions.flash.signout', :default => "Successfully signed out.", :user_name => user_name
    redirect_to user_session_end_url
  end
end