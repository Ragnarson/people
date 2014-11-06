module CheckAvailability
  def available_at?(user, date)
    @user = user
    bilable_count = billable_memberships_count
    (bilable_count == 0 || bilable_count <= finishing_work_count(date)) && !on_vacation_at?(date)
  end

  private

  def on_vacation_at?(date)
    vacation = @user.vacation
    return (vacation.starts_at.to_date <= date) && (vacation.ends_at.to_date >= date) if vacation
  end

  def billable_memberships_count
    @user.current_memberships.select(&:billable).count
  end

  def finishing_work_count(date)
    uniquee_projects = (ending_projects(date) + ending_memberships(date).map(&:project)).uniq
    uniquee_projects.count
  end

  def ending_memberships(date)
    @user.current_memberships.select { |p| p.billable && p.ends_at < date + 14.days if p.ends_at }
  end

  def ending_projects(date)
    current_projects.select { |p| p.end_at < date + 14.days if p.end_at.present? }
  end

  def current_projects
    @user.current_memberships.select(&:billable).map(&:project)
  end
end
