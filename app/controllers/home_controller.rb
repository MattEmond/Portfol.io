class HomeController < ApplicationController

skip_before_action :verify_authenticity_token, only: [:index]

  def index
    if params[:id] == ""
      @nothing = "Please enter a symbol"
    elsif

      if params[:id]
        begin
          @stock = StockQuote::Stock.quote(params[:id])
          @stock_json = StockQuote::Stock.json_quote(params[:id])
        rescue StandardError
          @error = "That stock symbol is not valid"
        end

      end
    end
  end

  def about

  end

end
