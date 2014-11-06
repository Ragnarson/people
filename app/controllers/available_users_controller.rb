class AvailableUsersController < ApplicationController

  expose_decorated(:users) { available_users }
  expose_decorated(:roles) { Role.technical }

  def index; end

  private

  def available_users
    @roles = Role.technical.to_a
    date = params[:available].nil? ? Time.now : params[:available][:date]
    User.filter_by(date).active.roles(@roles)
  end
end
