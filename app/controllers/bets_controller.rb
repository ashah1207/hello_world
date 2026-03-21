class BetsController < ApplicationController
  before_action :require_login
  before_action :set_market

  def create
    @bet = @market.bets.build(bet_params)
    @bet.user = current_user
    @bet.anonymous = current_user.anonymous_default? || params[:bet][:anonymous] == '1'

    if @market.status == 'settling'
      handle_settlement_vote
    elsif @bet.save
      flash[:notice] = "Bet placed! $#{@bet.amount} on '#{@bet.market_option.label}'. Good luck!"
      redirect_to @market
    else
      flash[:alert] = @bet.errors.full_messages.join(", ")
      redirect_to @market
    end
  end

  private

  def set_market
    @market = Market.includes(:market_options).find(params[:market_id])
  end

  def bet_params
    params.require(:bet).permit(:market_option_id, :amount, :anonymous)
  end

  def handle_settlement_vote
    winning_option_id = params[:bet][:market_option_id]
    @market.settle!(winning_option_id)
    flash[:notice] = "Outcome submitted! Payouts have been distributed."
    redirect_to @market
  end
end
