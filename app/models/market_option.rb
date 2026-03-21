class MarketOption < ApplicationRecord
  belongs_to :market
  has_many :bets, dependent: :destroy

  validates :label, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
end
