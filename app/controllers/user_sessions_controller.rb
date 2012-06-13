class UserSessionsController < ApplicationController
  # before_filter :require_no_user, :only => [:new, :create]
  # before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Successfully signed in."
      redirect_to root_url
    else
      flash[:error] = "Invalid email/password combination."
      redirect_to signin_path
    end
  end
  
  def destroy    
    current_user_session.destroy    
    flash[:success] = "Successfully signed out."    
    redirect_to root_url
  end
end