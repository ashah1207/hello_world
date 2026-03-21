class SessionsController < ApplicationController
  def new
    redirect_to markets_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)

    if user
      session[:user_id] = user.id
      flash[:notice] = "Welcome back, #{user.name}!"
      redirect_to markets_path
    else
      user = User.new(
        name: params[:name].to_s.strip,
        email: params[:email].to_s.downcase.strip
      )
      if user.save
        session[:user_id] = user.id
        flash[:notice] = "Account created! You have $#{user.balance} to start betting."
        redirect_to markets_path
      else
        flash.now[:alert] = user.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "You've been signed out."
    redirect_to new_session_path
  end
end
