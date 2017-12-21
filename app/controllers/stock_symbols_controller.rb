class StockSymbolsController < ApplicationController
  before_action :set_stock_symbol, only: [:show, :edit, :update, :destroy]

  # GET /stock_symbols
  # GET /stock_symbols.json
  def index
    @stock_symbols = StockSymbol.all
  end

  # GET /stock_symbols/1
  # GET /stock_symbols/1.json
  def show
  end

  # GET /stock_symbols/new
  def new
    @stock_symbol = StockSymbol.new
  end

  # GET /stock_symbols/1/edit
  def edit
  end

  # POST /stock_symbols
  # POST /stock_symbols.json
  def create
    @stock_symbol = StockSymbol.new(stock_symbol_params)

    respond_to do |format|
      if @stock_symbol.save
        format.html { redirect_to @stock_symbol, notice: 'Stock symbol was successfully created.' }
        format.json { render :show, status: :created, location: @stock_symbol }
      else
        format.html { render :new }
        format.json { render json: @stock_symbol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stock_symbols/1
  # PATCH/PUT /stock_symbols/1.json
  def update
    respond_to do |format|
      if @stock_symbol.update(stock_symbol_params)
        format.html { redirect_to @stock_symbol, notice: 'Stock symbol was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock_symbol }
      else
        format.html { render :edit }
        format.json { render json: @stock_symbol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_symbols/1
  # DELETE /stock_symbols/1.json
  def destroy
    @stock_symbol.destroy
    respond_to do |format|
      format.html { redirect_to stock_symbols_url, notice: 'Stock symbol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_symbol
      @stock_symbol = StockSymbol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_symbol_params
      params.require(:stock_symbol).permit(:exchange, :symbol, :company_name, :sector, :industry)
    end
end
