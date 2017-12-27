class Stock < ApplicationRecord

  belongs_to :user

  before_save :uppercase_ticker

  def uppercase_ticker
    ticker.upcase!
  end

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
end
