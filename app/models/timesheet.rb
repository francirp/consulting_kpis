class Timesheet < ApplicationRecord
  HOURS_PER_DAY = 7.2
  belongs_to :team_member
  has_many :timesheet_allocations, dependent: :destroy
  accepts_nested_attributes_for :timesheet_allocations, allow_destroy: true, :reject_if => lambda { |t| t[:allocation] == "0.0" }

  validates :team_member, :week, presence: true

  validate :validate_fully_allocated

  enum status: [:not_started, :draft, :finalized]  

  before_create :set_initial_status
  before_update :set_status_to_draft

  def non_working_days
    attributes["non_working_days"] || 0.0
  end

  def working_days_for_week
    5.0 - non_working_days
  end

  def working_hours_for_week
    working_days_for_week * HOURS_PER_DAY
  end

  def total_hours
    team_member.billable_target_ratio * working_hours_for_week
  end

  def finalize
    entries = Timesheets::ConvertToTimeEntries.new(self).call
    entries.each do |time_entry_hash|
      HarvestApi::CreateTimeEntries.new(time_entry_hash).call
    end
    self.status = 'finalized'
    self.save
  end

  private

  def validate_fully_allocated
    return true if timesheet_allocations.empty?
    total = timesheet_allocations.sum(&:allocation)
    return true if total >= 1.0
    self.errors.add(:base, "Allocated #{total.round(3)} - must allocate 1.0")
  end

  def set_initial_status
    self.status = 'not_started'
  end

  def set_status_to_draft
    # only set to draft when allocations are present 
    # and the status is currently "not_started"
    return unless not_started?
    self.status = 'draft' if timesheet_allocations.any?
  end
end
