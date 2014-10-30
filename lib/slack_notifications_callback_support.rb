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
  end

  def update_msg
    if self.changed?
      SLACK.send(self.class.name.downcase, self, 'updated')
    end
  end

  def destroy_msg
    SLACK.send(self.class.name.downcase, self, 'removed')
  end
end
