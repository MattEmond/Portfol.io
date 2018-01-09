class PortfolioCache

  def initialize current_user
    @portfolio = []
    current_user.stocks.each do |stock|
      stock_quote = StockQuote::Stock.quote(stock.ticker)
      @portfolio.push({name: stock_quote.name,
                        ticker: stock.ticker,
                        last_price: stock_quote.l,
                        market_cap: stock_quote.mc,
                        quantity: stock.quantity,
                        sector: stock_quote.sname,
                        price_as_number: stock_quote.l.delete(',').to_f,
                        total_value: stock_quote.l.delete(',').to_f * stock.quantity
                      })
    end
  return @portfolio
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