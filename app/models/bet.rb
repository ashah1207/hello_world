class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :market
  belongs_to :market_option

  validates :amount, numericality: { greater_than: 0 }
  validate :user_has_sufficient_balance, on: :create
  validate :market_is_open, on: :create
  validate :subject_not_blacklisted, on: :create

  before_create :deduct_from_wallet
  after_create :update_pool_totals

  def display_user
    anonymous? ? "Anonymous" : user.name
  end

  private

  def user_has_sufficient_balance
    errors.add(:amount, "exceeds your wallet balance") if user && amount && user.balance < amount
  end

  def market_is_open
    errors.add(:market, "is not accepting bets") unless market&.status == 'open'
  end

  def subject_not_blacklisted
    errors.add(:market, "cannot be created - subject has opted out") if market&.has_subject_blacklisted?
  end

  def deduct_from_wallet
    user.decrement!(:balance, amount)
  end

  def update_pool_totals
    market_option.increment!(:total_amount, amount)
    market.increment!(:total_pool, amount)
  end
end
