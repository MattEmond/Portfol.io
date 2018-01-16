class PortfolioCache

  attr_reader :contents
  attr_reader :tickers

  def initialize user
    @contents = PortfolioCache.build_portfolio_cache(user)
    @tickers = PortfolioCache.portfolio_tickers(user)
  end

  def self.build_portfolio_cache user
    tickers = portfolio_tickers(user)
    tickers_for_api_call = tickers*", "
    stocks = Array.wrap(StockQuote::Stock.quote(tickers_for_api_call))
    stocks2 = JSON.parse(RestClient.get "https://api.iextrading.com/1.0/stock/FB/quote")
    contents = []
    stocks.each do |stock|
      contents.push({id: Stock.where(:ticker => stock.symbol).pluck(:id)[0],
                        name: stocks2['companyName'],
                        ticker: stock.symbol,
                        last_price: stocks2['latestPrice'],
                        market_cap: stocks2['marketCap'],
                        quantity: Stock.where(:ticker => stock.symbol).pluck(:quantity)[0],
                        sector: stock.sname,
                        price_as_number: stock.l.delete(',').to_f,
                        total_value: (stock.l.delete(',').to_f * Stock.where(:ticker => stock.symbol).pluck(:quantity)[0]).round(2)
                      })
    end
    return contents
  end

  def self.portfolio_tickers user
    tickers = []
    user.stocks.each do |stock|
      tickers.push(stock.ticker)
    end
    return tickers
  end

  def self.portfolio_total_value current_user, cache = @contents
    current_user_portfolio_total = 0
    portfolio_cache = cache ? cache : build_portfolio_cache(current_user)
    portfolio_cache.each do |stock|
      current_user_portfolio_total += stock[:total_value]
    end
    return current_user_portfolio_total
  end

  def self.industry_breakdown current_user, cache = @contents
    current_user_portfolio_total = portfolio_total_value(current_user, @portfolio_cache)
    portfolio_cache = cache ? cache : build_portfolio_cache(current_user)
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

  def self.industry_breakdown_for_highcharts current_user
    stock_portfolio = []
      industry_breakdown = PortfolioCache.industry_breakdown(current_user)
      industry_breakdown.each do |industry|
        stock_portfolio << {:sector => industry[0], :percentage => industry[1]}
      end
    return stock_portfolio
  end

  def self.find_portfolio_similarity_scores portfolio
    tickers = portfolio_tickers(portfolio)
    portfolio_scores = {}
    Stock.find_each do |stock|
      if stock.user_id == portfolio.id
        next
      # If the stock is in both portfolios, that user gets a point
      elsif tickers.include?(stock.ticker) && portfolio_scores[stock.user_id]
        portfolio_scores[stock.user_id] += 1
      elsif tickers.include?(stock.ticker)
        portfolio_scores[stock.user_id] = 1
      end
    end
    return portfolio_scores
  end

  def self.similar_portfolio_filtering portfolio
    # https://stackoverflow.com/questions/2440826/collaborative-filtering-in-mysql
    recommendation_scores = {}
    tickers = portfolio_tickers(portfolio)
    portfolio_scores = find_portfolio_similarity_scores(portfolio)
    Stock.find_each do |stock|
      if tickers.include? stock.ticker
        next
      # If the stock is already recommended, add its owner's portfolio score
      elsif recommendation_scores[stock.ticker] && portfolio_scores[stock.user_id] != nil
        recommendation_scores[stock.ticker] += portfolio_scores[stock.user_id]
      # If the stock is not already recommended, set its score to its owner's portfolio's score
      elsif portfolio_scores[stock.user_id] != nil
        recommendation_scores[stock.ticker] = portfolio_scores[stock.user_id]
      end
    end
    return recommendation_scores
  end


end

=begin

  def initialize
    @contents = {}
  end

  def [] symbol
    if !@contents.includes? symbol
      # make api call

      # TODO!
      raise NotImplementedError

      # store in dictionary
      @contents[symbol] = APICALL
    end
    @contents.fetch symbol
  end
end

# i = IndustryCache.new
# i["GOOG"]


=end