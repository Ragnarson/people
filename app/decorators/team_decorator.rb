class TeamDecorator < Draper::Decorator
  delegate_all
  decorates_association :users

  def get_leader
    leader.present? ? "\nLeader: `#{leader.decorate.name}`" : ""
  end

  def teammates
    users.present? ? "\nTeammates: `#{users.map { |u| u.name }.join(", ")}`" : ""
  end
end
