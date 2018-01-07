class IndustryCache
  def initialize
    @contents = {}
  end

  def [] symbol
    current_user_portfolio_total = Stock.build_current_user_portfolio_total_value(current_user)
    current_user_portfolio = []
    current_user.stocks.each do |stock|
      sector = StockQuote::Stock.quote(stock.ticker).sname
      stock_price = StockQuote::Stock.quote(stock.ticker).l.delete(',').to_f
      if current_user_portfolio[sector]
        current_user_portfolio[sector] += stock_price * stock.quantity/current_user_portfolio_total
      elsif current_user_portfolio[sector] == nil && current_user_portfolio['Other']
        current_user_portfolio['Other'] += stock_price * stock.quantity/current_user_portfolio_total
      elsif sector == nil
        current_user_portfolio['Other'] = stock_price * stock.quantity/current_user_portfolio_total
      else
        current_user_portfolio[sector] = StockQuote::Stock.quote(stock.ticker).l.delete(',').to_f * stock.quantity/current_user_portfolio_total
      end
    end
    return current_user_portfolio
  end
end

=begin
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