module LoginMacros
  def set_user_session(user)
    session[:user_id] = user.id
  end

  def current_user_id
    session[:user_id]
  end

end
