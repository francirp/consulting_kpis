class TimeEntry < ApplicationRecord
  belongs_to :project
  belongs_to :team_member, optional: true
  belongs_to :client, optional: true

  scope :earliest, -> { order("spent_at ASC") }
  scope :latest, -> { order("spent_at DESC") }
  scope :billable, -> { where(billable: true) }

  scope :between, ->(start_date, end_date) { where('spent_at >= ? AND spent_at <= ?', start_date, end_date) }
  scope :current_year, ->{ where('spent_at >= ? AND spent_at <= ?', Date.today.beginning_of_year, Date.today.end_of_year) }

  attr_accessor :user_name

  def week_num
    spent_at.strftime("%U").to_i
  end

  def year
    spent_at.year
  end

  def cost
    return 0.00 unless rounded_hours && cost_rate
    (rounded_hours * cost_rate).round(2)
  end

  def maintenance?
    project.try(:name) == 'Monthly Maintenance'
  end

  def streamlined_checkout?
    project.try(:client).try(:name) == 'Centaman'
  end

  def self.rows
    users = HarvestedWrapper.new.users
    projects_by_id = Project.all.group_by(&:id)
    clients_by_id = Client.all.group_by(&:id)
    time_entries = self.current_year.earliest.includes(:project).map.with_index do |time_entry, index|
      date = time_entry.spent_at
      display_date = date.strftime('%m/%d/%Y')
      project = projects_by_id[time_entry.project_id].first
      next unless project.client_id
      client = clients_by_id[project.client_id].first
      client_name = client.try(:name)
      user = users.detect { |u| u["id"] == time_entry.harvest_user_id }
      project_name = project.try(:name)
      hours = time_entry.hours
      hours_rounded = time_entry.rounded_hours
      # TODO: fix week calc
      week = date.strftime("%U").to_i
      row = [
        index + 2,
        display_date,
        client_name,
        project_name,
        hours,
        hours_rounded,
        time_entry.billable,
        time_entry.is_billed,
        user['first_name'],
        user['last_name'],
        date.year,
        date.month,
        week,
        time_entry.maintenance?,
        time_entry.streamlined_checkout?,
        time_entry.billable_rate,
      ]
      row
    end.compact
    return time_entries
  end
end
