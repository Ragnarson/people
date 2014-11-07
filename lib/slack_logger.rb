class SlackLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n"
  end
end

logfile = File.open("#{Rails.root}/log/slack_log", 'a')
logfile.sync = true
SLACK_LOGGER = SlackLogger.new(logfile)
