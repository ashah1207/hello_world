class LeaderboardController < ApplicationController
  def index
    settled_bets = Bet.where(settled: true)
    user_stats = settled_bets.group(:user_id)
                             .select('user_id,
                                      SUM(COALESCE(payout_amount, 0)) as total_payouts,
                                      SUM(amount) as total_wagered,
                                      COUNT(*) as total_bets,
                                      SUM(CASE WHEN payout_amount > 0 THEN 1 ELSE 0 END) as wins')

    @leaderboard = user_stats.map do |stat|
      user = User.find_by(id: stat.user_id)
      next unless user
      profit = stat.total_payouts.to_f - stat.total_wagered.to_f
      {
        user: user,
        profit: profit.round(2),
        total_bets: stat.total_bets.to_i,
        wins: stat.wins.to_i,
        win_rate: stat.total_bets.to_i > 0 ? (stat.wins.to_f / stat.total_bets * 100).round(1) : 0
      }
    end.compact.sort_by { |s| -s[:profit] }.first(20)

    @most_active = User.joins(:bets).group('users.id').order('COUNT(bets.id) DESC').limit(5)
  end
end
