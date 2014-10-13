class ProjectDecorator < Draper::Decorator
  delegate_all

  def attributes
    potential = self.potential ? "potential " : ""
    archived = self.archived ? "archived " : ""

    (potential + archived + "project:").strip.capitalize
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
