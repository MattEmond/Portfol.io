module StocksHelper

  def find_most_popular
    popularity = {}
    Stock.all.each do |stock|
      if popularity[stock.ticker.to_sym]
        popularity[stock.ticker.to_sym] += 1
      else
        popularity[stock.ticker.to_sym] = 1
      end
    end
    return popularity
  end

  def display_most_popular
    recommendations = find_most_popular.sort_by {|_key, value| value}.reverse
    content_tag :ul do
      recommendations.collect { |stock| concat(content_tag(:li, stock[0])) }
    end
  end

  def build_current_user_portfolio
    current_user_portfolio = {}
    Stock.all.each do |stock|
      if stock.user_id == current_user.id
        current_user_portfolio[stock.ticker.to_sym] = stock.quantity
      end
    end
    return current_user_portfolio
  end

  def find_portfolio_similarity_score
    current_user_portfolio = build_current_user_portfolio
    portfolio_scores = {}
    Stock.all.each do |stock|
      if stock.user_id == current_user.id
        next
      # If the stock is in both portfolios, that user gets a point
      elsif current_user_portfolio[stock.ticker.to_sym] && portfolio_scores[stock.user_id]
        portfolio_scores[stock.user_id] += 1
      elsif current_user_portfolio[stock.ticker.to_sym]
        portfolio_scores[stock.user_id] = 1
      end
    end
    return portfolio_scores
  end

  def display_similar_portfolios
    recommendations = find_portfolio_similarity_score.sort_by {|_key, value| value}.reverse
    content_tag :ul do
      recommendations.collect { |portfolio| concat(content_tag(:li, User.where(:id => portfolio[0]).pluck(:username)[0])) }
    end
  end

  def similar_portfolio_filtering
    # https://stackoverflow.com/questions/2440826/collaborative-filtering-in-mysql
    recommendation_scores = {}
    current_user_portfolio = build_current_user_portfolio
    portfolio_scores = find_portfolio_similarity_score
    Stock.all.each do |stock|
      ticker_as_symbol = stock.ticker.to_sym
      if current_user_portfolio[ticker_as_symbol]
        next
      # If the stock is already recommended, add the portfolio's score to the stock's recommendation score
      elsif recommendation_scores[ticker_as_symbol]
        recommendation_scores[ticker_as_symbol] += portfolio_scores[stock.user_id]
      # If the stock is not stored
      else
        recommendation_scores[ticker_as_symbol] = portfolio_scores[stock.user_id]
      end
    end
    return recommendation_scores
  end

  def display_similar_portfolio_filtering
    recommendations = similar_portfolio_filtering.sort_by {|_key, value| value}.reverse
    content_tag :ul do
      recommendations.collect { |stock| concat(content_tag(:li, stock[0])) }
    end
  end

end