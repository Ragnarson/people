module SlackNotificationsCallbackSupport
  extend ActiveSupport::Concern

  included do
    unless SLACK.nil?
      after_create :create_msg
      after_update :update_msg
      before_destroy :destroy_msg
    end
  end

  private

  def create_msg
    SLACK.send(self.class.name.downcase, self, 'added')
  end

  def update_msg
    return SLACK.send(self.class.name.downcase, self, 'updated') if self.changed?
  end

  def destroy_msg
    SLACK.send(self.class.name.downcase, self, 'removed')
  end
end
