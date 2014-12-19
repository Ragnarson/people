class VacationChecker
  include Calendar

  def initialize(vacation)
    @vacation = vacation
  end

  def check!
    if @vacation.ends_at < Date.today
      delete_vacation(@vacation)
      @vacation.delete(@vacation)
    end
  end
end
