module LoginMacros
  def set_user_session(user)
    session[:user_id] = user.id
  end

  def current_user_id
    session[:user_id]
  end

  def login_as(user, options = {})
    email     = options[:email] || user.email
    password  = options[:password] || user.password

    visit root_path
    click_link 'Log in'
    fill_in 'session[email]', with: email
    fill_in 'session[password]', with: password
    click_button 'Log in'
  end

end
