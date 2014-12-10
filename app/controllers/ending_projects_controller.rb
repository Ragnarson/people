class EndingProjectsController < ApplicationController
  expose(:projects) { ending_projects }

  def index; end

  private

  def ending_projects
    date = params[:ending].nil? ? 2.weeks.from_now : params[:ending][:date]
    Project.filter_by(date).active.asc(:end_at)
  end
end
