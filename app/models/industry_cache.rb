class IndustryCache
  def initialize
    @contents = {}
  end

  def [] symbol
    current_user_portfolio_total = Stock.build_current_user_portfolio_total_value(current_user)
    current_user.stocks.each do |stock|
      sector = Ticker.where(:symbol => stock.ticker).pluck(:sector)[0]
      if @contents[sector]
        @contents += StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
      elsif @contents == nil && @contents['Other']
        @contents['Other'] += StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
      elsif StockQuote::Stock.quote(stock.ticker).sname == nil
        @contents['Other'] = StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
      else
        @contents[StockQuote::Stock.quote(stock.ticker).sname] = StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
      end
    end
    @contents.fetch current_user_portfolio
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