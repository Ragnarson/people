require 'slack-notify'

class Slack
  attr_reader :client

  def initialize
    @client = SlackNotify::Client.new(AppConfig.slack.team, AppConfig.slack.token, {
      channel: AppConfig.slack.channel,
      username: AppConfig.slack.username,
      icon_url: AppConfig.slack.icon_url
    })
  end

  def project(p, action)
    if p.potential == true && p.archived == false
      if p.kickoff.present? && p.end_at.blank?
        @client.notify("Potential project: `#{p}` has been `#{action}`. Kickoff: `#{p.kickoff}`.")
      end

      if p.kickoff.blank? && p.end_at.present?
        @client.notify("Potential project: `#{p}` has been `#{action}`. End at: `#{p.end_at.to_date}`.")
      end

      if p.kickoff.present? && p.end_at.present?
        @client.notify(
          "Potential project: `#{p}` has been `#{action}`. Kickoff: `#{p.kickoff}`, End at: `#{p.end_at.to_date}`.")
      end

      if p.kickoff.blank? && p.end_at.blank?
        @client.notify("Potential project: `#{p}` has been `#{action}`.")
      end
    end

    if p.archived == true && p.potential == false
      if p.kickoff.blank? && p.end_at.present?
        @client.notify("Archived project: `#{p}` has been `#{action}`. End at: `#{p.end_at.to_date}`.")
      end

      if p.kickoff.blank? && p.end_at.blank?
        @client.notify("Archived project: `#{p}` has been `#{action}`.")
      end
    end

    if p.archived == false && p.potential == false
      if p.kickoff.present? && p.end_at.blank?
        @client.notify("`#{p}` has been `#{action}`. Kickoff: `#{p.kickoff}`.")
      end

      if p.kickoff.blank? && p.end_at.present?
        @client.notify("`#{p}` has been `#{action}`. End at: `#{p.end_at.to_date}`.")
      end

      if p.kickoff.present? && p.end_at.present?
        @client.notify("`#{p}` has been `#{action}`. Kickoff: `#{p.kickoff}`, End at: `#{p.end_at.to_date}`.")
      end

      if p.kickoff.blank? && p.end_at.blank?
        @client.notify("`#{p}` has been `#{action}`.")
      end
    end

    if p.archived == true && p.potential == true
      if p.kickoff.blank? && p.end_at.present?
        @client.notify("Potential archived project: `#{p}` has been `#{action}`. End at: `#{p.end_at.to_date}`.")
      end

      if p.kickoff.blank? && p.end_at.blank?
        @client.notify("Potential archived project: `#{p}` has been `#{action}`.")
      end
    end
  end

  def membership(m, action)
    case action
    when "removed"
      @client.notify(
        "`#{m.user.first_name} #{m.user.last_name}` has been `#{action}` from project: `#{m.project}`.")
    when "added"
      @client.notify(
        "`#{m.user.first_name} #{m.user.last_name}` has been `#{action}` to project: `#{m.project}`.")
    end
  end

  def vacation(v, action)
    @client.notify(
      "Vacation has been `#{action}`. `#{v.user.first_name} #{v.user.last_name}`: `#{v.date_range}`.")
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
        "#{p}: `#{m.user.first_name} #{m.user.last_name}` will `#{action}` work at: `#{m.ends_at.to_date}`.")
    when "start"
      @client.notify(
        "#{p}: `#{m.user.first_name} #{m.user.last_name}` will `#{action}` work at: `#{m.starts_at.to_date}`.")
    end
  end
end

