class VacationChecker
  include Calendar

  attr_reader :vacation

  def initialize(vacation)
    @vacation = vacation
  end

  def check!
    if vacation.ends_at < Date.today
      delete_vacation(vacation)
      vacation.delete(vacation)
    end
  end
end
