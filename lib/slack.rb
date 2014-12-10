require 'slack-notify'

class Slack
  attr_reader :client

  def initialize
    @client = SlackNotify::Client.new(
      AppConfig.slack.team,
      AppConfig.slack.token,
      channel: AppConfig.slack.channel,
      username: AppConfig.slack.username,
      icon_url: AppConfig.slack.icon_url
      )
  end

  def project(p, action)
    project = p.decorate
    @client.notify("#{project.attributes} `#{p}` has been `#{action}`.#{project.dates}")
  end

  def membership(m, action)
    case action
    when "removed"
      @client.notify(
        "`#{m.user.name}` has been `#{action}` from project: `#{m.project}`.")
    when "added"
      @client.notify(
        "`#{m.user.name}` has been `#{action}` to project: `#{m.project}`.")
    end
  end

  def vacation(v, action)
    @client.notify(
      "Vacation has been `#{action}`. `#{v.user.name}`: `#{v.date_range}`.")
  end

  def team(t, action)
    @client.notify("Team: `#{t.name}` has been `#{action}`.")
  end

  def project_checker(p, action)
    case action
    when "finished"
      @client.notify("`#{p.name}` will be `#{action}` at: `#{p.end_at.to_date}`.")
    when "started"
      @client.notify("`#{p.name}` will be `#{action}` at: `#{p.kickoff.to_date}`.")
    end
  end

  def member_checker(p, m, action)
    case action
    when "finish"
      @client.notify(
        "#{p}: `#{m.user.name}` will `#{action}` work at: `#{m.ends_at.to_date}`.")
    when "start"
      @client.notify(
        "#{p}: `#{m.user.name}` will `#{action}` work at: `#{m.starts_at.to_date}`.")
    end
  end
end
