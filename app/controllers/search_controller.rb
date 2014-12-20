class SearchController < ApplicationController
  include SearchHelper

  def index
    key_word, order = parse_search_param(params[:q])
    @links = Link.search_by_title(key_word).order_by(order).includes(:user, :comments).paginate(page: params[:page])
    @count = @links.count
  end
end
