class SessionsController < ApplicationController
  before_action :check_login, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        flash[:success] = 'Log in success'
        redirect_back_or @user
      else
        flash[:warning] = 'Account not activated. Check your email for the activation link.'
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid info'
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = 'Log out success'
    redirect_to root_url
  end

  private

  def check_login
    if logged_in?
      flash[:warning] = "You've already logged in."
      redirect_to root_url
    end
  end
end
