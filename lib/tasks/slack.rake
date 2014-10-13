namespace :slack do
  task notification: :environment do
    Project.all.each do |project|
      SlackNotificationJob.new.perform(project.id)
    end
  end
end
