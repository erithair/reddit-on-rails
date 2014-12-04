class SearchController < ApplicationController
  include SearchHelper

  before_action :collapse_comments, only: [:index]

  def index
    key_word, order = parse_search_param(params[:q])
    @links = Link.search(title: key_word).order_by(order).includes(:user, :comments).paginate(page: params[:page])
    @count = @links.count
  end
end
