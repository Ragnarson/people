class UserMailer < BaseMailer
  def notify_operations(email)
    @email = email
    to = Settings.notifications_email || AppConfig.emails.support
    mail(to: to, subject: "New user in the application.", email: @email)
  end
end
