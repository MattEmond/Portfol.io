class Stock < ApplicationRecord

  belongs_to :user

  before_save :uppercase_ticker

  def uppercase_ticker
    ticker.upcase!
  end

end