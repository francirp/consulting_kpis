class AsanaTask < ApplicationRecord
  belongs_to :team_member, optional: true
  belongs_to :asana_project
end
