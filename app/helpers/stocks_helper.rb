module StocksHelper

  def display_most_popular
    most_popular = Stock.find_most_popular.first(5).sort_by {|_key, value| value}.reverse
    content_tag :ul do
      most_popular.collect { |stock| concat(content_tag(:li, stock[0].to_s + ' : ' + stock[1].to_s)) }
    end
  end

  def display_similar_portfolio_filtering
    recommendations = Stock.similar_portfolio_filtering(current_user).first(5).sort_by {|_key, value| value}.reverse
    content_tag :ul do
      recommendations.collect { |stock| concat(content_tag(:li, stock[0].to_s + ' : ' + stock[1].to_s)) }
    end
  end

  def display_current_user_industry_breakdown
    current_user_portfolio = Stock.build_current_user_industry_breakdown(current_user)
    content_tag :ul do
      current_user_portfolio.collect { |industry| concat(content_tag(:li, industry)) }
    end
  end

  def display_similar_portfolios
    similar_portfolios = Stock.find_portfolio_similarity_score(current_user).sort_by {|_key, value| value}.reverse
    content_tag :ul do
      similar_portfolios.collect { |portfolio| concat(content_tag(:li, User.where(:id => portfolio[0]).pluck(:username)[0])) }
    end
  end

end