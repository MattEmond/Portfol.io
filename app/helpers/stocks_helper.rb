module StocksHelper

  def display_most_popular
    most_popular = Stock.find_most_popular.sort_by {|_key, value| value}.reverse.first(5)
    content_tag :ul do
      most_popular.collect { |stock| concat(content_tag(:li, stock[0].to_s + ' : ' + stock[1].to_s)) }
    end
  end

  def display_similar_portfolio_filtering
    recommendations = PortfolioCache.similar_portfolio_filtering(current_user).sort_by {|_key, value| value}.reverse.first(5)
    content_tag :ul do
      recommendations.collect { |stock| concat(content_tag(:li, stock[0].to_s + ' : ' + stock[1].to_s)) }
    end
  end

  def display_similar_portfolios
    similar_portfolios = PortfolioCache.find_portfolio_similarity_scores(current_user).sort_by {|_key, value| value}.reverse.first(5)
    content_tag :ul do
      similar_portfolios.collect { |portfolio| concat(content_tag(:li, User.where(:id => portfolio[0]).pluck(:username)[0] + ' : ' + portfolio[1].to_s)) }
    end
  end

end