class CommentsController < ApplicationController
  before_action :set_link
  before_action :set_comment,      only: :destroy
  before_action :requires_login,   only: [:create, :destroy]
  before_action :user_check,       only: :destroy

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.link = @link
    if @comment.save
      flash[:success] = "Comment success"
      redirect_to @link
    else
      render 'links/show'
    end
  end

  def index
    # don't like it
    # @links = Link.includes(:user, :comments).paginate(page: params[:page])
    # @comments = @link.comments.includes(:user)
    # @comment = currrent_user.comments.build(link: @link)
    # render 'links/index'

    redirect_to @link
  end

  def destroy
    @comment.destroy
    flash[:success] = 'delete the comment'
    redirect_to @link
  end

  private

  def user_check
    unless current_user == @link.user
      flash[:warning] = "You can't delete other's comments"
      redirect_to @link and return
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_link
    @link = Link.find(params[:link_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
