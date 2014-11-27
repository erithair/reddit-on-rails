module ApplicationHelper
  def full_title(title = '')
    base_title = 'RedditOnRails'
    title.empty? ? base_title : "#{title} - #{base_title}"
  end

  def if_link_active(actual, expect)
    actual == expect ? 'active' : ''
  end

  def if_voted(options = {})
    link = options[:link]
    comment = options[:comment]
    up = options[:up]
    type = link ? 'Link' : 'Comment'

    if current_user && vote = current_user.votes.find_by(votable_id: link || comment, votable_type: type)
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
