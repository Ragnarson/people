class HipChat::Notifier
  attr_reader :client

  def initialize
    @client = HipChat::Client.new(AppConfig.features.hipchat.api_token)
  end

  def send_notification(message)
    @client[AppConfig.features.hipchat.room_name].send(
      AppConfig.hipchat.author_name,
      message,
      notify: AppConfig.features.hipchat.notify_users,
      color: AppConfig.features.hipchat.message_color
    )
  end
end

