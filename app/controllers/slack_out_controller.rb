class SlackOutController < ApplicationController
  include SlashCommands

  before_action :check_token
  skip_before_action :authenticate_user!, only: :check_command

  def check_command
    head :no_content
    command = params['text']
    send_to = '@' + params['user_name']
    execute(command, send_to)
  end

  private

  def check_token
    slack_token = AppConfig.slack.slash_cmd_token
    return render text: 'No authentication!' if slack_token != params['token'] || SLACK.nil?
  end
end
