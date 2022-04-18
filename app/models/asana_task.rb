class AsanaTask < ApplicationRecord
  belongs_to :team_member, optional: true
  belongs_to :asana_project
  belongs_to :client, optional: true

  enum unit_type: [:dev_days, :hours, :points]

  scope :completed_between, ->(start_date, end_date) { where('completed_on >= ? AND completed_on <= ?', start_date, end_date) }

  # def calculate_dev_days
  #   return 0.0 if size.nil?
  #   return size if dev_days? || points? # TODO: how to convert to dev days from points? Probably should go the other direction.
  #   return size / 6.0 if hours?
  # end
end
