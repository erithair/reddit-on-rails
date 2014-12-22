class Links::VotesController < CommentsController
  before_action :requires_login

  def create
    link = Link.find(params[:link_id])
    if current_user.vote(link, params[:up])
      flash[:success] = 'vote success'
      redirect_to links_url
    else
      flash[:warning] = 'you can only vote once for each link'
      redirect_to links_url
    end
  end
end
