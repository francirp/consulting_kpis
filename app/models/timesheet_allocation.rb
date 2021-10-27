class TimesheetAllocation < ApplicationRecord
  belongs_to :timesheet
  belongs_to :project
  belongs_to :task

  validates :allocation, numericality: { greater_than_or_equal_to: 0.0 }
end
