module ApplicationHelper
  def full_title(title = '')
    base_title = 'RedditOnRails'
    title.empty? ? base_title : "#{title} - #{base_title}"
  end

  def if_link_active(actual, expect)
    actual == expect ? 'active' : ''
  end

end
