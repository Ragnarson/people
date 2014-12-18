module SlashCommands
  COMMANDS_MATCHERS = { project: /project/,
                                                contact: /contact/,
                                                team: /team/,
                                                vacation: /vacation/,
                                                member: /member/,
                                                available: /available/ }
  def execute(command, send_to)
    COMMANDS_MATCHERS.each do |type, regex|
      send(type, command, send_to) if command =~ regex && !SLACK.nil?
    end
  end

  private

  def project(command, send_to)
    command.gsub!('project ', '')
    project = Project.where(name: Regexp.new(command, 'i')).first
    project_notification(project, send_to)
  end

  def contact(command, send_to)
    command.gsub!('contact ', '')
    arr = command.split.to_a
    user = User.where(first_name: arr[0], last_name: arr[1]).first
    user_notification(user, send_to)
  end

  def team(command, send_to)
    command.gsub!('team ', '')
    team = Team.where(name: Regexp.new(command, 'i')).first
    team_notification(team, send_to)
  end

  def vacation(command, send_to)
    command.gsub!('vacation ', '')
    arr = command.split.to_a
    user = User.where(first_name: arr[0], last_name: arr[1]).first
    vacation_notification(user, send_to)
  end

  def available(command, send_to)
    command.gsub!('available ', '')
    user = User.where(available: true)
    available_notification(user, send_to)
  end

  def member(command, send_to)
    command.gsub!('member ', '')
    arr = command.split.to_a
    user = User.where(first_name: arr[0], last_name: arr[1]).first
    member_notification(user, send_to)
  end

  def project_notification(project, send_to)
    if project.present?
      project = project.decorate
      SLACK.client.notify(
        "#{project.attributes} `#{project}`: #{project.dates} #{project.members}", "#{send_to}")
    else
      not_found('Project', send_to)
    end
  end

  def user_notification(user, send_to)
    if user.present?
      SLACK.client.notify("`#{user.decorate.name}`:#{user.decorate.contact_details}", "#{send_to}")
    else
      not_found('Contact', send_to)
    end
  end

  def team_notification(team, send_to)
    if team.present?
      team = team.decorate
      SLACK.client.notify(
        "Team `#{team.name}`:#{team.get_leader} #{team.teammates}", "#{send_to}")
    else
      not_found('Team', send_to)
    end
  end

  def vacation_notification(user, send_to)
    vacations = user.vacations if user
    if vacations.present?
      vacations.each do |vacation|
        SLACK.client.notify(
          "Vacation: `#{user.name}` - `#{vacation.date_range}`.", "#{send_to}")
      end
    else
      not_found('Vacation', send_to)
    end
  end

  def available_notification(user, send_to)
    if user.present?
      SLACK.client.notify(
        "Available users: `#{user.map(&:name).join(', ')}`.", "#{send_to}")
    else
      not_found('Available users', send_to)
    end
  end

  def member_notification(user, send_to)
    member = Membership.where(user_id: user.id).map { |m| m.project.name } if user.present?
    if member.present?
      SLACK.client.notify(
        "#{user.name + "'s"} project(s): `#{member.join(', ')}`.", "#{send_to}")
    else
      not_found('Member', send_to)
    end
  end

  def not_found(object, send_to)
    SLACK.client.notify("`#{object} was not found.`", "#{send_to}")
  end
end
