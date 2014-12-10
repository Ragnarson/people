class ProjectDecorator < Draper::Decorator
  decorates_association :memberships, scope: :only_active
  delegate_all

  def starts
    kickoff.present? ? kickoff.to_date : "-"
  end
end
