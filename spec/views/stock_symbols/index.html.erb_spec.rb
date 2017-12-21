require 'rails_helper'

RSpec.describe "stock_symbols/index", type: :view do
  before(:each) do
    assign(:stock_symbols, [
      StockSymbol.create!(
        :exchange => "Exchange",
        :symbol => "Symbol",
        :company_name => "Company Name",
        :sector => "Sector",
        :industry => "Industry"
      ),
      StockSymbol.create!(
        :exchange => "Exchange",
        :symbol => "Symbol",
        :company_name => "Company Name",
        :sector => "Sector",
        :industry => "Industry"
      )
    ])
  end

  it "renders a list of stock_symbols" do
    render
    assert_select "tr>td", :text => "Exchange".to_s, :count => 2
    assert_select "tr>td", :text => "Symbol".to_s, :count => 2
    assert_select "tr>td", :text => "Company Name".to_s, :count => 2
    assert_select "tr>td", :text => "Sector".to_s, :count => 2
    assert_select "tr>td", :text => "Industry".to_s, :count => 2
  end
end
