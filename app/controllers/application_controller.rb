class ApplicationController < ActionController::Base
  include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def requires_login
    unless logged_in?
      store_location
      flash[:warning] = 'You need to log in'
      redirect_to login_url and return
    end
  end

  def collapse_comments
    @collapse_comments = true
  end

  def set_order
    # avoid invalid info
    @order = {
      'latest'  => :latest,
      'rank'    => :rank,
      'hot'     => :hot
    }[params[:order]] || :latest
  end
end
