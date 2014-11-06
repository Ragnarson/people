class AvailabilityChecker
  include CheckAvailability

  def initialize user
    @user = user
  end

  def run!
    @user.update_attributes available: available_at?(@user, Time.now)
  end
end
