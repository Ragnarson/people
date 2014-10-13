require 'slack'

SLACK = AppConfig.slack.active == true ? Slack.new : nil
