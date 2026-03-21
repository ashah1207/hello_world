class User < ApplicationRecord
  has_many :created_markets, class_name: 'Market', foreign_key: :creator_id
  has_many :bets
  has_many :pool_memberships
  has_many :pools, through: :pool_memberships
  has_many :created_pools, class_name: 'Pool', foreign_key: :creator_id
  has_many :reports, foreign_key: :reporter_id

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def display_name(force_anon = false)
    (force_anon || anonymous_default?) ? "Anonymous" : name
  end

  def total_winnings
    bets.where(settled: true).where.not(payout_amount: nil).sum(:payout_amount) -
      bets.where(settled: true).sum(:amount)
  end

  def active_bets_total
    bets.where(settled: false).sum(:amount)
  end
end
