module SlashCommands
  SLACK = Hrguru::Application.config.slack.client

  COMMANDS_MATCHERS = { project: /project/,
                                                contact: /contact/,
                                                team: /team/,
                                                vacation: /vacation/,
                                                member: /member/,
                                                available: /available/ }
  def execute(command, send_to)
    COMMANDS_MATCHERS.each do |type, regex|
      if command =~ regex
        self.send(type, command, send_to)
        SLACK_LOGGER.info("Command: #{type} has been called.")
      end
    end
  end

  private

  def project(command, send_to)
    command.gsub!('project ', '')
    p = Project.where(name: Regexp.new(command, 'i')).first
    if p.present?
      SLACK.notify(
        "Project `#{p.name}`: Kickoff: `#{p.kickoff.present? ? p.kickoff : '-'}`, Ends at: `#{p.end_at.present? ? p.end_at.to_date : '-'}`. \nMembers: `#{p.memberships.present? ? p.memberships.map {|m| m.user.name}.join(", ") : '-'}`.", "#{send_to}")
    else
      not_found('Project', send_to)
    end
  end

  def contact(command, send_to)
    command.gsub!('contact ', '')
    user = command.split.to_a
    contact = User.where(first_name: user[0], last_name: user[1]).first
    if contact.present?
      SLACK.notify(
        "`#{contact.name}`:\nPhone: `#{contact.phone.present? ? contact.phone : '-'}`\nEmail: `#{contact.email.present? ? contact.email : '-'}`\nSkype: `#{contact.skype.present? ? contact.skype : '-'}`.", "#{send_to}")
    else
      not_found('Contact', send_to)
    end
  end

  def team(command, send_to)
    command.gsub!('team ', '')
    team = Team.where(name: Regexp.new(command, 'i')).first
    if team.present?
      SLACK.notify(
        "Team `#{team.name}`: \nLeader: `#{team.leader.present? ? team.leader.name : "-"}`\nTeammates: `#{team.users.present? ? team.users.map {|u| u.name}.join(", ") : '-'}`.", "#{send_to}")
    else
      not_found('Team', send_to)
    end
  end

  def vacation(command, send_to)
    command.gsub!('vacation ', '')
    arr = command.split.to_a
    user = User.where(first_name: arr[0], last_name: arr[1]).first
    v = Vacation.where(user_id: user.id).first if user.present?
    if v.present?
      SLACK.notify(
        "Vacation: `#{user.name}` - `#{v.date_range}`.", "#{send_to}")
    else
      not_found('Vacation', send_to)
    end
  end

  def available(command, send_to)
    command.gsub!('available ', '')
    av = User.where(available: true)
    if av.present?
      SLACK.notify(
        "Available users: `#{av.map { |u| u.name }.join(", ")}`.", "#{send_to}")
    else
      not_found('Available users', send_to)
    end
  end

  def member(command, send_to)
    command.gsub!('member ', '')
    arr = command.split.to_a
    user = User.where(first_name: arr[0], last_name: arr[1]).first
    member = Membership.where(user_id: user.id).map {|m| m.project.name} if user.present?
    if member.present?
      SLACK.notify(
        "#{user.name+"'s"} project(s): `#{member.join(", ")}`.", "#{send_to}")
    else
      not_found('Member', send_to)
    end
  end

  def not_found(object, send_to)
    SLACK.notify("`#{object} was not found.`", "#{send_to}")
  end
end
