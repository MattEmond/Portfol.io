module StocksHelper

  def find_most_popular
    popularity = {}
    Stock.all.each do |stock|
      if popularity[stock.ticker]
        popularity[stock.ticker] += 1
      else
        popularity[stock.ticker] = 1
      end
    end
    return popularity.sort_by {|_key, value| value}.reverse
  end

  def display_most_popular
    recommendations = find_most_popular
    content_tag :ul do
      recommendations.collect { |stock| concat(content_tag(:li, stock[0])) }
    end
  end

  def find_portfolio_similarity_score
    portfolios = {}
    Stock.all.each do |stock|
      if stock.user_id != current_
        if popularity[stock.ticker]
          popularity[stock.ticker] += 1
        else
          popularity[stock.ticker] = 1
        end
    end
    return popularity.sort_by {|_key, value| value}.reverse
  end

  def display_most_popular
    recommendations = find_most_popular
    content_tag :ul do
      recommendations.collect { |stock| concat(content_tag(:li, stock[0])) }
    end
  end


end