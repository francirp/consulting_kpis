class FeedbackRequest < ApplicationRecord
  has_secure_token :token
  belongs_to :surveyable, polymorphic: true
  validates :date, presence: true
  belongs_to :client
  scope :recent, -> { order("date DESC") }

  enum rating: [
    :not_rated,
    :unhappy,
    :neutral,
    :happy,
  ]
end
