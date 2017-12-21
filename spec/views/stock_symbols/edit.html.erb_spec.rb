require 'rails_helper'

RSpec.describe "stock_symbols/edit", type: :view do
  before(:each) do
    @stock_symbol = assign(:stock_symbol, StockSymbol.create!(
      :exchange => "MyString",
      :symbol => "MyString",
      :company_name => "MyString",
      :sector => "MyString",
      :industry => "MyString"
    ))
  end

  it "renders the edit stock_symbol form" do
    render

    assert_select "form[action=?][method=?]", stock_symbol_path(@stock_symbol), "post" do

      assert_select "input[name=?]", "stock_symbol[exchange]"

      assert_select "input[name=?]", "stock_symbol[symbol]"

      assert_select "input[name=?]", "stock_symbol[company_name]"

      assert_select "input[name=?]", "stock_symbol[sector]"

      assert_select "input[name=?]", "stock_symbol[industry]"
    end
  end
end
