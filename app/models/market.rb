class Market < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :pool, optional: true
  belongs_to :resolved_option, class_name: 'MarketOption', optional: true
  has_many :market_options, dependent: :destroy
  has_many :bets, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :title, presence: true
  validates :end_time, presence: true
  validates :house_cut_pct, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validate :end_time_in_future, on: :create

  scope :open, -> { where(status: 'open') }
  scope :settling, -> { where(status: 'settling') }
  scope :resolved, -> { where(status: 'resolved') }
  scope :active, -> { where(status: %w[open settling]) }
  scope :recent, -> { order(created_at: :desc) }
  scope :trending, -> { open.order(total_pool: :desc) }

  STATUSES = %w[open settling resolved].freeze
  MARKET_TYPES = %w[binary multi].freeze

  def odds_for(option)
    return 50.0 if total_pool.zero?
    (option.total_amount / total_pool * 100).round(1)
  end

  def implied_probability(option)
    odds_for(option)
  end

  def american_odds(option)
    prob = implied_probability(option) / 100.0
    return "+100" if prob == 0.5
    if prob > 0.5
      favorite = -(prob / (1 - prob) * 100).round
      "#{favorite}"
    else
      underdog = ((1 - prob) / prob * 100).round
      "+#{underdog}"
    end
  end

  def payout_multiplier(option)
    return 0 if option.total_amount.zero?
    net_pool = total_pool * (1 - house_cut_pct / 100.0)
    (net_pool / option.total_amount).round(2)
  end

  def settle!(winning_option_id)
    return unless status == 'settling'
    option = market_options.find(winning_option_id)
    winners = bets.where(market_option_id: winning_option_id)
    multiplier = payout_multiplier(option)

    ActiveRecord::Base.transaction do
      winners.each do |bet|
        payout = (bet.amount * multiplier).round(2)
        bet.update!(payout_amount: payout, settled: true)
        bet.user.increment!(:balance, payout)
      end
      bets.where.not(market_option_id: winning_option_id).update_all(settled: true, payout_amount: 0)
      update!(status: 'resolved', resolved_option_id: winning_option_id)
    end
  end

  def has_subject_blacklisted?
    return false if subject_name.blank?
    User.where("LOWER(name) = ?", subject_name.downcase).where(blacklisted: true).exists?
  end

  private

  def end_time_in_future
    errors.add(:end_time, "must be in the future") if end_time.present? && end_time <= Time.current
  end
end
