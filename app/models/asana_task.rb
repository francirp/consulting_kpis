class AsanaTask < ApplicationRecord
  belongs_to :team_member, optional: true
  belongs_to :asana_project

  enum unit_type: [:dev_days, :hours, :points]
end
