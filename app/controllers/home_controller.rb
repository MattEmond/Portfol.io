class HomeController < ApplicationController
require 'rest-client'
skip_before_action :verify_authenticity_token, only: [:index]

  def index

  end

   def search

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

def historical_chart_home
    historical = RestClient.get "https://api.iextrading.com/1.0/stock/#{params[:id]}/chart/5y"

    respond_to do |format|
      format.json { render json: historical, status: :ok }
      format.html
    end
  end

  def stock_news_home
    news = RestClient.get "https://api.iextrading.com/1.0/stock/#{params[:id]}/news/last/5"

    respond_to do |format|
      format.json { render json: news, status: :ok }
      format.html
    end
  end

  def about

  end

end
