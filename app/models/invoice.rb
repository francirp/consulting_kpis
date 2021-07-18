class Invoice < ApplicationRecord
  belongs_to :client
  scope :between, ->(start_date, end_date) { 
    # where('period_end >= ? AND period_end <= ? OR period_end IS NULL', start_date, end_date)
    where('issue_date >= ? AND issue_date <= ?', start_date.beginning_of_month + 14.days, (end_date + 1.week).end_of_month - 14.days)
  }
  scope :non_retainers, -> { where.not(is_retainer: true) }
end
