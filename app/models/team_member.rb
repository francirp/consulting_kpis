class TeamMember < ApplicationRecord
  scope :contractors, -> { where(is_contractor: true) }
end
