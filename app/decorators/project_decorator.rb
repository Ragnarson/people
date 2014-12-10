class ProjectDecorator < Draper::Decorator
  decorates_association :memberships, scope: :only_active
  delegate_all

  def attributes
    potential = self.potential ? "potential " : ""
    archived = self.archived ? "archived " : ""

    (potential + archived + "project:").strip.capitalize
  end

  def kicks_off_at
    kickoff if kickoff.present?
  end

  def starts
    kickoff.present? ? " Kickoff: `#{kickoff}`." : ""
  end

  def ends
    end_at.present? ? " End at: `#{end_at.to_date}`." : ""
  end

  def dates
    starts + ends
  end

  def members
    memberships.present? ? "\nMembers: `#{memberships.map { |m| m.user.name }.join(", ")}`." : ""
  end
end
