class SlackNotification

  def initialize(project)
    @project = project
  end

  def notify
    if @project.end_at.present?
      case @project.end_at.to_date
      when 1.week.from_now.to_date, 1.day.from_now.to_date
        Hrguru::Application.config.slack.project_checker(@project, 'finished')
      end
    end

    if @project.kickoff.present? && @project.archived == false
      case @project.kickoff.to_date
      when 1.week.from_now.to_date, 1.day.from_now.to_date
        Hrguru::Application.config.slack.project_checker(@project, 'started')
      end
    end

    @project.memberships.each do |m|
      if @project.archived == false && @project.potential == false && m.ends_at.present?
        case m.ends_at.to_date
        when 1.week.from_now.to_date, 1.day.from_now.to_date
          Hrguru::Application.config.slack.member_checker(@project.name, m, 'finish')
        end
      end

      if @project.archived == false && @project.potential == false && m.starts_at.present?
        case m.starts_at.to_date
        when 1.week.from_now.to_date, 1.day.from_now.to_date
          Hrguru::Application.config.slack.member_checker(@project.name, m, 'start')
        end
      end
    end
  end
end
