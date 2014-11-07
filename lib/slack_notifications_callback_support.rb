module SlackNotificationsCallbackSupport
  extend ActiveSupport::Concern
  SLACK = Hrguru::Application.config.slack

  included do
    after_create :create_msg
    after_update :update_msg
    before_destroy :destroy_msg
  end

  private

  def create_msg
    SLACK.send(self.class.name.downcase, self, 'added')
    SLACK_LOGGER.info("Create notification for: #{self.class.name} has been sent.")
  end

  def update_msg
    if self.changed?
      SLACK.send(self.class.name.downcase, self, 'updated')
      SLACK_LOGGER.info("Update notification for: #{self.class.name} has been sent.")
    end
  end

  def destroy_msg
    SLACK.send(self.class.name.downcase, self, 'removed')
    SLACK_LOGGER.info("Destroy notification for: #{self.class.name} has been sent.")
  end
end
