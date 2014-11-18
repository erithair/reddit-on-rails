class SearchController < ApplicationController
  def index
    @links = Link.search(title: params[:q]).includes(:user, :comments).paginate(page: params[:page])
  end
end
