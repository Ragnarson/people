class VacationCheckerJob
  include SuckerPunch::Job

  def perform(vacation)
    VacationChecker.new(vacation).check! if vacation.present?
  end
end
