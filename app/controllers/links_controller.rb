class LinksController < ApplicationController
  before_action :set_link,          only: [:show, :edit, :update, :destroy, :vote]
  before_action :set_comment_obj,   only: :show
  before_action :set_order,         only: [:show, :index]
  before_action :requires_login,    only: [:new, :create, :edit, :update, :destroy, :vote]
  before_action :user_check,        only: [:edit, :update, :destroy]

  def new
    @link = current_user.links.build
  end

  def create
    @link = current_user.links.build(link_params)
    if @link.save
      flash[:success] = 'create a new link'
      redirect_to links_url
    else
      render :index
    end
  end

  def show
    @comments = @link.comments.send(@order).includes(:user)
  end

  def index
    @links = Link.send(@order).includes(:user).paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @link.update(link_params)
      flash[:success] = 'update the link'
      redirect_to links_url
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    flash[:success] = 'delete the link'
    redirect_to links_url
  end

  def vote
    if current_user.vote(votable_id: @link.id, votable_type: 'Link', up: params[:up])
      flash[:success] = 'vote success'
      redirect_to links_url
    else
      flash[:warning] = 'you can only vote once for each link'
      redirect_to links_url
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :title)
  end

  # hook methods

  def set_order
    # avoid invalid info
    @order = {
      'latest'  => :latest,
      'rank'    => :rank,
      'hot'     => :hot
      }[params[:order]] || :latest
  end

  def set_comment_obj
    @comment = Comment.new
  end

  def set_link
    @link = Link.find(params[:id])
  end

  def user_check
    unless current_user == @link.user
      flash[:warning] = 'this link belongs to other user'
      redirect_to links_url and return
    end
  end
end
