
class Stock < ApplicationRecord

  belongs_to :user

  before_save :uppercase_ticker

  def uppercase_ticker
    ticker.upcase!
  end

  validates :ticker, :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }


  def self.find_most_popular
    popularity = {}
    Stock.find_each do |stock|
      if popularity[stock.ticker.to_sym]
        popularity[stock.ticker.to_sym] += 1
      else
        popularity[stock.ticker.to_sym] = 1
      end
    end
    return popularity
  end

end
