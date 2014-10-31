module SessionsHelper
  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||=
      if user_id = session[:user_id]
        User.find_by(id: user_id)
      elsif user_id = cookies.signed[:user_id]
        user = User.find_by(id: user_id)
        log_in user and user if user && user.authenticated?(cookies[:remember_token])
      end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete :user_id
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
