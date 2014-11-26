module UsersHelper
  def handdle_request
    @request = {
      'links'    => :links,
      'comments' => :comments
    }[params[:request]] || :links

    case @request
    when :links
      @links = @user.links.includes(:user)
    when :comments
      @comments = @user.comments
    else
      # extend in the future
    end
  end
end
