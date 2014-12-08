module ApplicationHelper
  def full_title(title = '')
    base_title = 'RedditOnRails'
    title.empty? ? base_title : "#{title} - #{base_title}"
  end

  def if_link_active(actual, expect)
    actual == expect ? 'active' : ''
  end

  def if_voted(options = {})
    user = options[:user] || current_user
    return '' unless user # only logged in user can see if he/she've voted or not

    link = options[:link]
    comment = options[:comment]
    up = options[:up]
    type = link ? 'Link' : 'Comment'

    if vote = Vote.find_by(user_id: user, votable_id: link || comment, votable_type: type)
      if vote.up == up
        up == 1 ? 'voted-up voted-disable' : 'voted-down voted-disable'
      else
        'voted-disable'
      end
    else
      ''
    end
  end
end
