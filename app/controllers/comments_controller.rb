class CommentsController < ApplicationController
  before_action :set_link
  before_action :requires_login, only: [:new, :create, :destroy]
  before_action :user_check, only: :destroy

  def new

  end

  def create

  end

  def index
    @links = Link.includes(:user, :comments).paginate(page: params[:page])
    @comments = @link.comments
    render 'links/index'
  end

  def destroy

  end

  private

  def set_link
    @link = Link.find(params[:link_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
