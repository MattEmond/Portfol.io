class Stock < ApplicationRecord

  belongs_to :user

  before_save :uppercase_ticker

  def uppercase_ticker
    ticker.upcase!
  end

  validates :ticker, :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def self.find_most_popular
    popularity = {}
    Stock.find_each do |stock|
      if popularity[stock.ticker.to_sym]
        popularity[stock.ticker.to_sym] += 1
      else
        popularity[stock.ticker.to_sym] = 1
      end
    end
    return popularity
  end

  def self.build_current_user_portfolio_total_value current_user
    current_user_portfolio_total = 0
    current_user.stocks.each do |stock|
      current_user_portfolio_total += StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity
    end
    return current_user_portfolio_total
  end

  def self.build_current_user_industry_breakdown current_user
    current_user_portfolio_total = Stock.build_current_user_portfolio_total_value(current_user)
    current_user_portfolio = {}
    current_user.stocks.each do |stock|
      sector = Ticker.where(:symbol => stock.ticker).pluck(:sector)[0]
      stock_price = StockQuote::Stock.quote(stock.ticker).l.delete(',').to_f
      if current_user_portfolio[sector]
        current_user_portfolio[sector] += stock_price * stock.quantity/current_user_portfolio_total
      elsif current_user_portfolio[sector] == nil && current_user_portfolio['Other']
        current_user_portfolio['Other'] += stock_price * stock.quantity/current_user_portfolio_total
      elsif StockQuote::Stock.quote(stock.ticker).sname == nil
        current_user_portfolio['Other'] = stock_price * stock.quantity/current_user_portfolio_total
      else
        current_user_portfolio[StockQuote::Stock.quote(stock.ticker).sname] = stock_price * stock.quantity/current_user_portfolio_total
      end
    end
    return current_user_portfolio
  end

  def self.build_current_user_portfolio current_user
    current_user_portfolio_total = Stock.build_current_user_portfolio_total_value(current_user)
    current_user_portfolio = {}
    current_user.stocks.each do |stock|
      current_user_portfolio[stock.ticker.to_sym] = StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
    end
    return current_user_portfolio
  end

  def self.find_portfolio_similarity_score current_user
    current_user_portfolio = build_current_user_portfolio(current_user)
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

  def self.similar_portfolio_filtering current_user
    # https://stackoverflow.com/questions/2440826/collaborative-filtering-in-mysql
    recommendation_scores = {}
    current_user_portfolio = build_current_user_portfolio(current_user)
    portfolio_scores = find_portfolio_similarity_score(current_user)
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

end
