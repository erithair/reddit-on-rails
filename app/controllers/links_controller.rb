class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_action :requires_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :user_check, only: [:edit, :update, :destroy]

  def new
    @link = current_user.links.build
  end

  def create
    @link = current_user.links.build(link_params)
    if @link.save
      flash[:success] = 'create a new link'
      redirect_to links_url
    else
      render :new
    end
  end

  def show
  end

  def index
    @links = Link.includes(:user)
  end

  def edit
  end

  def update
    if @link.update(link_params)
      flash[:success] = 'update the link'
      redirect_to link_url(@link)
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    flash[:success] = 'delete the link'
    redirect_to links_url
  end

  private

  def user_check
    unless current_user == @link.user
      flash[:warning] = 'this link belongs to other user'
      redirect_to links_url and return
    end
  end

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:url, :title)
  end
end
