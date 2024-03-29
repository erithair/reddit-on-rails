class PasswordResetsController < ApplicationController
  before_action :set_user,          only: [:edit, :update]
  before_action :valid_user,        only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions."
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found."
      render :new
    end
  end

  def edit
  end

  def update
    if both_passwords_blank?
      flash.now[:danger] = "Password/confirmation can't be blank"
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def both_passwords_blank?
    params[:user][:password].blank? &&
    params[:user][:password_confimation].blank?
  end

  def set_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless(@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      flash[:warning] = 'Invalid info'
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'Password reset has expired.'
      redirect_to new_password_reset_url
    end
  end
end
