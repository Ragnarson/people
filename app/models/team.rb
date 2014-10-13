class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :users, inverse_of: :team
  has_one :leader, class_name: 'User', inverse_of: :leader_team

  accepts_nested_attributes_for :users

  after_create { |team| Hrguru::Application.config.slack.team(team, "added") }
  after_update { |team| Hrguru::Application.config.slack.team(team, "updated") }
  before_destroy { |team| Hrguru::Application.config.slack.team(team, "removed") }
end
