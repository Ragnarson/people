module CheckAvailability

  def available_at?(user, date)
    assign_user(user)
    bilable_count = billable_memberships_count
    (bilable_count == 0 || bilable_count <= finishing_work_count(date)) && !on_vacation_at?(date) && (internal_projects_count == 0) && potential_projects_count == 0
  end

  private

  def assign_user(user)
    @user = user
  end

  def on_vacation_at?(date)
    if @user.vacation.present?
      (@user.vacation.starts_at.to_date <= date) && (@user.vacation.ends_at.to_date >= date)
    end
  end

  def internal_projects_count
    @user.current_memberships.map(&:project).select{|p| p.internal == true}.count
  end

  def potential_projects_count
    @user.current_memberships.map(&:project).select{|p| p.potential == true}.count
  end

  def billable_memberships_count
    @user.current_memberships.select { |m| m.billable == true }.count
  end

  def finishing_work_count(date)
    uniquee_projects = ( ending_projects(date) + ending_memberships(date).map(&:project)).uniq
    uniquee_projects.count
  end

  def ending_memberships(date)
    @user.current_memberships.select { |p| p.billable == true && p.ends_at < date +14.days if p.ends_at.present? }
  end

  def ending_projects(date)
    current_projects.select { |p| p.end_at < date +14.days if p.end_at.present? }
  end

  def current_projects
    @user.current_memberships.select { |m| m.billable == true }.map(&:project)
  end
end
