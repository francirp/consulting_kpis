class TeamMember < ApplicationRecord
  default_scope { order(first_name: :asc) }
  scope :contractors, -> { where(is_contractor: true) }
  scope :employees, -> { where.not(is_contractor: true) }
  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where.not(is_active: true) }
  has_many :time_entries
  
  def name
    [first_name, last_name].compact.join(' ')
  end

  def set_start_and_end_date
    entries = time_entries.order("spent_at ASC")
    self.start_date = entries.first.try(:spent_at)
    self.end_date = entries.last.try(:spent_at)
    self.save
  end

  def target_billable_ratio
    attributes['target_billable_ratio'] || 1.0 # default to 100% utilization
  end
end
