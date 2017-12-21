require "rails_helper"

RSpec.describe StockSymbolsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/stock_symbols").to route_to("stock_symbols#index")
    end

    it "routes to #new" do
      expect(:get => "/stock_symbols/new").to route_to("stock_symbols#new")
    end

    it "routes to #show" do
      expect(:get => "/stock_symbols/1").to route_to("stock_symbols#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/stock_symbols/1/edit").to route_to("stock_symbols#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/stock_symbols").to route_to("stock_symbols#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/stock_symbols/1").to route_to("stock_symbols#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/stock_symbols/1").to route_to("stock_symbols#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/stock_symbols/1").to route_to("stock_symbols#destroy", :id => "1")
    end

  end
end
