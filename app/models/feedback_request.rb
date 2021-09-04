class FeedbackRequest < ApplicationRecord
  has_secure_token :token
  belongs_to :contact
  validates :date, presence: true

  enum rating: [
    :not_rated,
    :unhappy,
    :neutral,
    :happy,
  ]
end
