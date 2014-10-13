require 'slack'

if AppConfig.slack.active
  Hrguru::Application.config.slack = Slack.new
end
