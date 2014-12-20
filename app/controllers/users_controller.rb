class UsersController < ApplicationController
  include UsersHelper

  before_action :set_user,                     only: [:show, :edit, :update, :destroy, :links, :comments]
  before_action :set_order,                    only: [:show, :links, :comments]
  before_action :set_links,                    only: [:show, :links]
  before_action :set_comments,                 only: [:comments]
  before_action :show_source_link_of_comment,  only: [:comments]

  # this will slow down the speed(more partial to render)
  # before_action :collapse_comments,            only: [:show, :links, :comments]

  before_action :disable_email_field,          only: [:edit, :update]

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
    render :show
  end

  def comments
    render :show
  end

  private

  def disable_email_field
    @disable_email_field = true
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_links
    @links = @user.links.order_by(@order).includes(comments: :user)
  end

  def set_comments
    @comments = @user.comments.order_by(@order).includes(:link)
  end

  def show_source_link_of_comment
    @show_source_link = true
  end

  def user_params
    input = [:username, :password, :password_confirmation]
    input << :email unless @disable_email_field
    params.require(:user).permit(*input)
  end
end
