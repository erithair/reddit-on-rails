module SearchHelper
  def parse_search_param(q)
    key_word, order = q.split('&:')
    [key_word, order ? order.to_sym : :latest]
  end
end
