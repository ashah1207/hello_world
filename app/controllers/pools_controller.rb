class PoolsController < ApplicationController
  before_action :require_login
  before_action :set_pool, only: [:show, :join, :leave]

  def index
    @public_pools = Pool.public_pools.includes(:creator, :members).order(:name)
    @my_pools = current_user.pools.includes(:creator, :members)
  end

  def show
    @markets = @pool.markets.recent.includes(:creator, :market_options).limit(20)
    @members = @pool.members.limit(20)
  end

  def new
    @pool = Pool.new
  end

  def create
    @pool = Pool.new(pool_params)
    @pool.creator = current_user

    if @pool.save
      @pool.pool_memberships.create!(user: current_user)
      flash[:notice] = "Pool '#{@pool.name}' created!"
      redirect_to @pool
    else
      flash.now[:alert] = @pool.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def join
    if @pool.pool_type == 'private' && params[:invite_code] != @pool.invite_code
      flash[:alert] = "Invalid invite code."
      redirect_to pools_path and return
    end

    if @pool.member?(current_user)
      flash[:alert] = "You're already a member of this pool."
    else
      @pool.pool_memberships.create!(user: current_user)
      flash[:notice] = "Joined pool '#{@pool.name}'!"
    end
    redirect_to @pool
  end

  def leave
    membership = @pool.pool_memberships.find_by(user: current_user)
    if membership
      membership.destroy
      flash[:notice] = "You left pool '#{@pool.name}'."
      redirect_to pools_path
    else
      flash[:alert] = "You are not a member of this pool."
      redirect_to @pool
    end
  end

  private

  def set_pool
    @pool = Pool.find(params[:id])
  end

  def pool_params
    params.require(:pool).permit(:name, :pool_type)
  end
end
