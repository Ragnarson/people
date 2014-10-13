class Vacation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :starts_at, type: Date
  field :ends_at, type: Date
  field :eventid

  belongs_to :user, inverse_of: :vacation

  validates :starts_at, :ends_at, presence: true

  after_create { |vacation| Hrguru::Application.config.slack.vacation(vacation, "added") }
  after_update { |vacation| Hrguru::Application.config.slack.vacation(vacation, "updated") }

  def date_range
    range = "#{starts_at.to_date}... #{ends_at.to_date}"
  end
end
