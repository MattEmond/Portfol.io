class CreateTickers < ActiveRecord::Migration[5.1]
  def change
    create_table :tickers do |t|
      t.string :exchange
      t.string :symbol
      t.string :name
      t.string :sector
      t.string :industry

      t.timestamps
    end
  end
end
