class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      flash[:success] = 'Log in success'
      redirect_to @user
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
end
