class TimeEntry < ActiveRecord::Base
  include Harvest::Calculations
  belongs_to :project

  scope :earliest, -> { order("spent_at ASC") }
  scope :latest, -> { order("spent_at DESC") }
  scope :billable, -> { order("spent_at DESC") }

  scope :between, ->(start_date, end_date) { where('spent_at >= ? AND spent_at <= ?', start_date, end_date) }

  attr_accessor :user_name

  def week_num
    spent_at.strftime("%U").to_i
  end

  def year
    spent_at.year
  end

  def self.rounded_hours(time_entries)
    return 0.00 unless time_entries.any?
    hours = time_entries.is_a?(Array) ? time_entries.map(&:hours) : time_entries.pluck(:hours)
    hours.map { |hour| Harvest::Calculations.roundup(hour) }.sum
  end
end
