class AvailableUsersController < ApplicationController
  expose(:users) { available_users.decorate }
  expose(:roles) { Role.technical.decorate }

  def index; end

  private

  def available_users
    @roles = Role.technical.to_a
    date = params[:available].nil? ? Time.now : params[:available][:date]
    User.filter_by(date).active.roles(@roles)
  end
end
