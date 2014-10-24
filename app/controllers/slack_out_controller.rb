class SlackOutController < ApplicationController
  include SlashCommands

  before_action :check_token
  skip_before_filter :authenticate_user!, only: :check_command

  def check_command
    head :no_content
    command = params['text']
    send_to = '@' + params['user_name']

    execute(command, send_to)
  end

  private

  def check_token
    unless AppConfig.slack.slash_cmd_token == params['token']
      render text: 'No authentication!'
    end
  end
end
