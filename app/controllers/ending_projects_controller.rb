class EndingProjectsController < ApplicationController
  expose(:projects) { ending_projects }
  expose(:memberships) { ending_memberships }

  def index; end

  private

  def ending_projects
    date = 2.months.from_now
    Project.filter_by(date).active.asc(:end_at)
  end

  def ending_memberships
    date = 2.months.from_now
    Membership.filter_by(date).active.asc(:ends_at)
  end
end
