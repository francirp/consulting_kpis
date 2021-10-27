class TeamMember < ApplicationRecord
  POTENTIAL_HOURS_PER_YEAR_PER_PERSON = 1572
  default_scope { order(first_name: :asc) }
  scope :contractors, -> { where(is_contractor: true) }
  scope :employees, -> { where.not(is_contractor: true) }
  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where.not(is_active: true) }
  has_many :time_entries
  has_many :projects, through: :time_entries
  belongs_to :task

  before_save :set_end_date, unless: :is_active?

  def billable_target_ratio
    attributes['billable_target_ratio'] || 1.0
  end

  def hours_billed(timeframe_start_date, timeframe_end_date)
    time_entries.billable.between(timeframe_start_date, timeframe_end_date).sum(:rounded_hours)
  end
  
  def name
    [first_name, last_name].compact.join(' ')
  end

  def set_start_and_end_date
    entries = time_entries.earliest
    self.start_date = entries.first.try(:spent_at)
    self.end_date = is_active? ? nil : entries.last.try(:spent_at) 
    self.save
  end

  def set_end_date
    self.end_date = time_entries.latest.first.try(:spent_at)
  end
end
