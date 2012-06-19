module UserSessionHelper

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def signed_in?
    current_user_session && current_user_session.user
  end

  def user_session_start_url
    if current_user.role? :admin
      admin_url
    else
      root_url
    end
  end

  def user_session_end_url
    root_url
  end

end
