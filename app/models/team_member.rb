class TeamMember < ApplicationRecord
  POTENTIAL_HOURS_PER_YEAR_PER_PERSON = 1572
  default_scope { order(first_name: :asc) }
  scope :contractors, -> { where(is_contractor: true) }
  scope :employees, -> { where.not(is_contractor: true) }
  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where.not(is_active: true) }
  has_many :time_entries

  def available_hours(timeframe_start_date, timeframe_end_date)
    return 0 unless start_date
    return 0 if start_date > timeframe_end_date # employee started after this reporting period
    return 0 if end_date && end_date < timeframe_start_date # employee ended before this reporting period
    team_member_start = [timeframe_start_date, start_date].max # because an employee can start before the reporting period
    # TODO: add accurate end date for each team member
    team_member_end = [timeframe_end_date, end_date].min # employee can end in the middle of this reporting period.
    days = (team_member_end - team_member_start).to_i
    potential_hours_per_day = POTENTIAL_HOURS_PER_YEAR_PER_PERSON/365    
    days * potential_hours_per_day
  end

  def hours_billed(timeframe_start_date, timeframe_end_date)
    time_entries.billable.between(timeframe_start_date, timeframe_end_date).sum(:rounded_hours)
  end
  
  def name
    [first_name, last_name].compact.join(' ')
  end

  def set_start_and_end_date
    entries = time_entries.order("spent_at ASC")
    self.start_date = entries.first.try(:spent_at)
    self.end_date = entries.last.try(:spent_at)
    self.save
  end
end
