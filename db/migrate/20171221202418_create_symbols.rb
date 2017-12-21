class CreateSymbols < ActiveRecord::Migration[5.1]
  def change
    create_table :symbols do |t|
      t.string :exchange
      t.string :symbol
      t.string :name
      t.string :sector
      t.string :industry
    end
  end
end
