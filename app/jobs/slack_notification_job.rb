class SlackNotificationJob
  include SuckerPunch::Job

  def perform(project_id)
    project = Project.find(project_id)
    SlackNotification.new(project).notify if project.present?
  end
end
