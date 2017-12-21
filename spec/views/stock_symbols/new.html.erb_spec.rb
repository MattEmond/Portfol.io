require 'rails_helper'

RSpec.describe "stock_symbols/new", type: :view do
  before(:each) do
    assign(:stock_symbol, StockSymbol.new(
      :exchange => "MyString",
      :symbol => "MyString",
      :company_name => "MyString",
      :sector => "MyString",
      :industry => "MyString"
    ))
  end

  it "renders new stock_symbol form" do
    render

    assert_select "form[action=?][method=?]", stock_symbols_path, "post" do

      assert_select "input[name=?]", "stock_symbol[exchange]"

      assert_select "input[name=?]", "stock_symbol[symbol]"

      assert_select "input[name=?]", "stock_symbol[company_name]"

      assert_select "input[name=?]", "stock_symbol[sector]"

      assert_select "input[name=?]", "stock_symbol[industry]"
    end
  end
end
