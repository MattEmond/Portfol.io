require 'rails_helper'

RSpec.describe "StockSymbols", type: :request do
  describe "GET /stock_symbols" do
    it "works! (now write some real specs)" do
      get stock_symbols_path
      expect(response).to have_http_status(200)
    end
  end
end
