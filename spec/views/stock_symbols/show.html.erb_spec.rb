require 'rails_helper'

RSpec.describe "stock_symbols/show", type: :view do
  before(:each) do
    @stock_symbol = assign(:stock_symbol, StockSymbol.create!(
      :exchange => "Exchange",
      :symbol => "Symbol",
      :company_name => "Company Name",
      :sector => "Sector",
      :industry => "Industry"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Exchange/)
    expect(rendered).to match(/Symbol/)
    expect(rendered).to match(/Company Name/)
    expect(rendered).to match(/Sector/)
    expect(rendered).to match(/Industry/)
  end
end
