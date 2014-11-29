class UsersController < ApplicationController
  include UsersHelper

  before_action :set_user, only: [:show, :edit, :update, :destroy, :links, :comments]
  before_action :set_order, only: [:show, :links, :comments]
  before_action :disable_email_field, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    redirect_to links_user_url
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'update success'
      redirect_to user_url(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'delete user'
    redirect_to root_url
  end

  def links
    @links = @user.links.order_by(@order).includes(:user)
    render :show
  end

  def comments
    @comments = @user.comments.order_by(@order).includes(:user)
    render :show
  end

  private

  def disable_email_field
    @disable_email_field = true
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    input = [:username, :password, :password_confirmation]
    input << :email unless @disable_email_field
    params.require(:user).permit(*input)
  end
end
