class UsersController < ApplicationController
  before_action :require_login

  def blacklist
    current_user.update!(blacklisted: !current_user.blacklisted?)
    status = current_user.blacklisted? ? "enabled" : "disabled"
    flash[:notice] = "Opt-out #{status}. #{current_user.blacklisted? ? 'No one can create markets about you.' : 'Others can now create markets about you.'}"
    redirect_to wallet_path
  end

  def toggle_anonymous
    current_user.update!(anonymous_default: !current_user.anonymous_default?)
    flash[:notice] = "Anonymous mode #{current_user.anonymous_default? ? 'enabled' : 'disabled'}."
    redirect_to wallet_path
  end
end
