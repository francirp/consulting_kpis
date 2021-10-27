module Timesheets
  class ConvertToTimeEntries
    attr_reader :timesheet

    def initialize(timesheet)
      @timesheet = timesheet
    end

    def call      
      entries = timesheet.timesheet_allocations.map do |timesheet_allocation|
        next if timesheet_allocation.allocation <= 0.0
        hours = timesheet_allocation.allocation * timesheet.total_hours
        days = timesheet.working_days_for_week.ceil
        hours_per_day = (hours / days).round(2)
        while days > 1 && hours_per_day < 1.0 # don't want a bunch of tiny time entries, group together
          days -= 1
          hours_per_day = (hours / days).round(2)
        end

        rounded_hours_per_day = hours_per_day.round

        total_used = 0 # round until last day, then use specific number

        randomized_dates = (1..days).map do |day|
          (timesheet.week + day.days - 1.day).strftime('%Y-%m-%d')
        end.shuffle # so that the specific number does not always fall on last day

        (1..days).map do |day|
          total_used += rounded_hours_per_day unless day == days
          {
            spent_date: randomized_dates[day - 1],
            user_id: timesheet.team_member.harvest_id,
            project_id: timesheet_allocation.project.harvest_id,
            task_id: timesheet_allocation.task.harvest_id,
            hours: day == days ? hours - total_used : rounded_hours_per_day,
            notes: timesheet_allocation.description,
          }
        end
      end.flatten.compact
    end
  end
end
