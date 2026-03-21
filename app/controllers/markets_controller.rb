class MarketsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_market, only: [:show, :settle, :report]

  def index
    @trending_markets = Market.open.trending.limit(5)
    @markets = Market.recent.includes(:creator, :market_options, :pool)
    @markets = @markets.where(status: params[:status]) if params[:status].present?
    @markets = @markets.where(pool_id: nil).or(@markets.where(pools: { pool_type: 'public' }))
                       .left_joins(:pool)
    @markets = @markets.limit(20)
  end

  def show
    @bets = @market.bets.includes(:user, :market_option).order(created_at: :desc).limit(10)
    @user_bet = current_user ? @market.bets.find_by(user: current_user) : nil
  end

  def new
    @market = Market.new
    @pools = current_user.pools.to_a + Pool.public_pools.to_a
    @pools.uniq!
  end

  def create
    @market = Market.new(market_params)
    @market.creator = current_user

    if @market.has_subject_blacklisted?
      flash.now[:alert] = "This person has opted out of being the subject of bets."
      render :new, status: :unprocessable_entity
      return
    end

    if @market.save
      build_options!
      flash[:notice] = "Market '#{@market.title}' created successfully!"
      redirect_to @market
    else
      @pools = current_user.pools.to_a + Pool.public_pools.to_a
      flash.now[:alert] = @market.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def settle
    unless @market.creator == current_user
      flash[:alert] = "Only the market creator can initiate settlement."
      redirect_to @market and return
    end

    @market.update!(status: 'settling')
    flash[:notice] = "Market is now in settling phase. Vote on the outcome below."
    redirect_to @market
  end

  def report
    report = @market.reports.build(
      reporter: current_user,
      reason: params[:reason],
      status: 'pending'
    )
    if report.save
      flash[:notice] = "Report submitted. Our moderation team will review it."
    else
      flash[:alert] = "Could not submit report: #{report.errors.full_messages.join(', ')}"
    end
    redirect_to @market
  end

  private

  def set_market
    @market = Market.includes(:market_options, :creator, :pool).find(params[:id])
  end

  def market_params
    params.require(:market).permit(:title, :description, :market_type, :end_time,
                                   :house_cut_pct, :pool_id, :subject_name)
  end

  def build_options!
    if @market.market_type == 'binary'
      @market.market_options.create!(label: 'Yes', total_amount: 0)
      @market.market_options.create!(label: 'No', total_amount: 0)
    else
      options = params[:options].to_s.split("\n").map(&:strip).reject(&:blank?)
      options.each { |label| @market.market_options.create!(label: label, total_amount: 0) }
    end
  end
end
