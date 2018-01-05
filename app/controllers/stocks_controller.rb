class StocksController < ApplicationController
  require 'rest-client'
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  before_action :current_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
    @new_stock = Stock.new
    @stock_portfolio = create_stock_portfolio
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
    @stock = Stock.find(params[:id])
  end

  def historical_chart
    historical = RestClient.get "https://api.iextrading.com/1.0/stock/#{params[:stock]}/chart/5y"

    respond_to do |format|
      format.json { render json: historical, status: :ok }
      format.html
    end
  end

  def stock_news
    news = RestClient.get "https://api.iextrading.com/1.0/stock/#{params[:stock]}/news/last/5"

    respond_to do |format|
      format.json { render json: news, status: :ok }
      format.html
    end
  end




  # GET /stocks/new
  def new
    @stock = Stock.new

  end

  # GET /stocks/1/edit
  def edit
    @stock = Stock.new
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to stocks_path, notice: 'Stock was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:ticker, :user_id, :quantity)
    end

    def correct_user
      @ticker = current_user.stocks.find_by(id: params[:id])
      redirect_to stocks_path, notice: "You are not authorized to edit this stock" if @ticker.nil?
    end

    # For pie chart

    def build_current_user_portfolio_industry_breakdown
      current_user_portfolio_total = build_current_user_portfolio_total_value
      current_user_portfolio = {}
      Stock.all.each do |stock|
        if stock.user_id == current_user.id
          if current_user_portfolio[StockQuote::Stock.quote(stock.ticker).sname]
            current_user_portfolio[StockQuote::Stock.quote(stock.ticker).sname] += StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
          elsif StockQuote::Stock.quote(stock.ticker).sname == nil && current_user_portfolio['Other']
            current_user_portfolio['Other'] += StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
          elsif StockQuote::Stock.quote(stock.ticker).sname == nil
            current_user_portfolio['Other'] = StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
          else
            current_user_portfolio[StockQuote::Stock.quote(stock.ticker).sname] = StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity/current_user_portfolio_total
          end
        end
      end
      return current_user_portfolio
    end

    def build_current_user_portfolio_total_value
      current_user_portfolio_total = 0
      Stock.all.each do |stock|
        if stock.user_id == current_user.id
          current_user_portfolio_total += StockQuote::Stock.quote(stock.ticker).l.to_f * stock.quantity
        end
      end
      return current_user_portfolio_total
    end


    def create_stock_portfolio
      @stock_portfolio = [{:ticker=>"AAPL", :sector=>"Technology", :percentage=>0.1074306343975424}, {:ticker=>"BA", :sector=>"Industrials", :percentage=>0.2991595960599083}, {:ticker=>"BAC", :sector=>"Financials", :percentage=>0.1878685453934968}, {:ticker=>"DAL", :sector=>"Industrials", :percentage=>0.2991539450191484}, {:ticker=>"GILD", :sector=>"Healthcare", :percentage=>0.2300891436401685}, {:ticker=>"TSLA", :sector=>"Cyclical Consumer Goods & Services", :percentage=>0.17543216265623196}]

      #@stocks.each do |stock|
        #if stock.user_id == current_user.id
        #@stock_portfolio.push ({ ticker: stock.ticker, sector: StockQuote::Stock.quote(stock.ticker).sname, percentage: build_current_user_portfolio_industry_breakdown[StockQuote::Stock.quote(stock.ticker).sname] })
      #end
    #end

      return @stock_portfolio
  end
end
