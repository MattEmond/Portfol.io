json.extract! stock_symbol, :id, :exchange, :symbol, :company_name, :sector, :industry, :created_at, :updated_at
json.url stock_symbol_url(stock_symbol, format: :json)
