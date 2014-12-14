module ApplicationHelper
  def full_title(title = '')
    base_title = 'RedditOnRails'
    title.empty? ? base_title : "#{title} - #{base_title}"
  end

  def if_link_active(actual, expect)
    actual == expect ? 'active' : ''
  end

  def vote_link_class(options = {})
    # convenience for development
    user = options[:user] || current_user

    link = options[:link]
    comment = options[:comment]
    up = options[:up]

    if user && user_vote_kind = user.vote_kind(link || comment)
      if user_vote_kind == up
        up == 1 ? 'voted-up voted-disable' : 'voted-down voted-disable'
      else
        'voted-disable'
      end
    else
      ''
    end
  end
end
