class Comments::VotesController < CommentsController
  before_action :requires_login

  def create
    comment = Comment.find(params[:comment_id])
    if current_user.vote(comment, params[:up])
      flash[:success] = 'vote success'
      redirect_to @link
    else
      flash[:warning] = 'you can only vote once for each link'
      redirect_to @link
    end
  end
end
