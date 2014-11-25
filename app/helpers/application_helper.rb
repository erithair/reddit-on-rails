module ApplicationHelper
  def full_title(title = '')
    base_title = 'RedditOnRails'
    title.empty? ? base_title : "#{title} - #{base_title}"
  end

  def is_link_active?(order)
    order == @order ? 'active' : ''
  end
end
