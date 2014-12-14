class CommentsController < ApplicationController
  before_action :set_link
  before_action :set_comment,      only: [:destroy, :vote]
  before_action :requires_login,   only: [:create, :destroy, :vote]
  before_action :user_check,       only: :destroy

  def create
    @comment = Comment.new(comment_params)
    if current_user.comment(@link, @comment)
      flash[:success] = "Comment success"
      redirect_to @link
    else
      render 'links/show'
    end
  end

  def index
    redirect_to link_url(@link, order: params[:order])
  end

  def destroy
    @comment.destroy
    flash[:success] = 'delete the comment'
    redirect_to @link
  end

  def vote
    if current_user.vote(@comment, params[:up])
      flash[:success] = 'vote success'
      redirect_to @link
    else
      flash[:warning] = 'you can only vote once for each link'
      redirect_to @link
    end
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
