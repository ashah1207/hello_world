class WalletsController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @active_bets = @user.bets.where(settled: false).includes(:market, :market_option).order(created_at: :desc)
    @settled_bets = @user.bets.where(settled: true).includes(:market, :market_option).order(updated_at: :desc).limit(20)
    @total_wagered = @user.bets.sum(:amount)
    @total_won = @user.bets.where(settled: true).sum(:payout_amount)
    @net_profit = @total_won - @user.bets.where(settled: true).sum(:amount)
  end

  def deposit
    amount = params[:amount].to_f
    if amount > 0 && amount <= 10_000
      current_user.increment!(:balance, amount)
      flash[:notice] = "$#{amount.round(2)} added to your wallet."
    else
      flash[:alert] = "Invalid deposit amount. Must be between $0.01 and $10,000."
    end
    redirect_to wallet_path
  end
end
