
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

  def self.build_current_user_portfolio_cache current_user
      @portfolio_cache = []
      current_user.stocks.each do |stock|
        stock_quote = StockQuote::Stock.quote(stock.ticker)
        @portfolio_cache.push({id: stock.id,
                          name: stock_quote.name,
                          ticker: stock.ticker,
                          last_price: stock_quote.l,
                          market_cap: stock_quote.mc,
                          quantity: stock.quantity,
                          sector: stock_quote.sname,
                          price_as_number: stock_quote.l.delete(',').to_f,
                          total_value: stock_quote.l.delete(',').to_f * stock.quantity
                        })
      end
      return @portfolio_cache
  end

  def self.reset_portfolio_cache
    @portfolio_cache = nil
  end

  def self.build_current_user_portfolio_total_value current_user, cache = nil
    current_user_portfolio_total = 0
    portfolio_cache = cache ? cache : build_current_user_portfolio_cache(current_user)
    portfolio_cache.each do |stock|
      current_user_portfolio_total += stock[:total_value]
    end
    return current_user_portfolio_total
  end

  def self.build_current_user_industry_breakdown current_user, cache = nil
    current_user_portfolio_total = build_current_user_portfolio_total_value(current_user)
    portfolio_cache = cache ? cache : build_current_user_portfolio_cache(current_user)
    current_user_portfolio = {}
    portfolio_cache.each do |stock|
      sector = stock[:sector]
      stock_total_value = stock[:total_value]
      if current_user_portfolio[sector]
        current_user_portfolio[sector] += stock_total_value/current_user_portfolio_total
      elsif current_user_portfolio[sector] == nil && current_user_portfolio['Other']
        current_user_portfolio['Other'] += stock_total_value/current_user_portfolio_total
      elsif sector == nil
        current_user_portfolio['Other'] = stock_total_value/current_user_portfolio_total
      else
        current_user_portfolio[sector] = stock_total_value/current_user_portfolio_total
      end
    end
    return current_user_portfolio
  end

  def self.build_current_user_portfolio current_user, cache = nil
    current_user_portfolio_total = build_current_user_portfolio_total_value(current_user)
    portfolio_cache = cache ? cache : build_current_user_portfolio_cache(current_user)
    current_user_portfolio = {}
    portfolio_cache.each do |stock|
      current_user_portfolio[stock[:ticker]] = stock[:total_value]/current_user_portfolio_total
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
      elsif current_user_portfolio[stock.ticker] && portfolio_scores[stock.user_id]
        portfolio_scores[stock.user_id] += 1
      elsif current_user_portfolio[stock.ticker]
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
      if current_user_portfolio[stock.ticker]
        next
      # If the stock is already recommended, add the portfolio's score to the stock's recommendation score
      elsif recommendation_scores[stock.ticker] && portfolio_scores[stock.user_id] != nil
        recommendation_scores[stock.ticker] += portfolio_scores[stock.user_id]
      # If the stock is not stored
      elsif portfolio_scores[stock.user_id] != nil
        recommendation_scores[stock.ticker] = portfolio_scores[stock.user_id]
      end
    end
    return recommendation_scores
  end

end