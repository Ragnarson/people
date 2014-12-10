class SlackNotification
  def initialize(project)
    @project = project
  end

  def notify
    check_project
    check_members
  end

  def check_project
    project_finished if @project.end_at.present?
    project_started if @project.kickoff.present? && !@project.archived
  end

  def check_members
    return if @project.archived && @project.potential
    @project.memberships.each do |m|
      member_finished(m) if m.ends_at.present?
      member_started(m) if m.starts_at.present?
    end
  end

  private

  def project_finished
    case @project.end_at.to_date
    when 1.week.from_now.to_date, 1.day.from_now.to_date
      SLACK.project_checker(@project, 'finished')
    end
  end

  def project_started
    case @project.kickoff.to_date
    when 1.week.from_now.to_date, 1.day.from_now.to_date
      SLACK.project_checker(@project, 'started')
    end
  end

  def member_finished(membership)
    case membership.ends_at.to_date
    when 1.week.from_now.to_date, 1.day.from_now.to_date
      SLACK.member_checker(@project.name, membership, 'finish')
    end
  end

  def member_started(membership)
    case membership.starts_at.to_date
    when 1.week.from_now.to_date, 1.day.from_now.to_date
      SLACK.member_checker(@project.name, membership, 'start')
    end
  end
end
