module Reporting
  class EmployeeKeyMetrics
    AVAILABLE_HOURS_PER_PERSON = 1572.0
    BASELINE_TARGET_HOURS_PER_PERSON = 1300.0

    attr_reader :filter, :employee, :employee_time_entries
    delegate :time_entries, :start_date, :end_date, to: :filter

    def initialize(filter, employee, opts = {})
      @filter = filter
      @employee = employee
      @employee_time_entries = opts[:time_entries]
    end

    def available_hours
      return 0 unless employee.start_date
      return 0 if employee.start_date > end_date # employee started after this reporting period
      return 0 if employee.end_date && employee.end_date < start_date # employee ended before this reporting period
      team_member_start = [start_date, employee.start_date].compact.max # because an employee can start before the reporting period
      # TODO: add accurate end date for each team member
      team_member_end = [end_date, employee.end_date].compact.min # employee can end in the middle of this reporting period.
      days = (team_member_end - team_member_start).to_i + 1
      potential_hours_per_day = AVAILABLE_HOURS_PER_PERSON/365.0
      days * potential_hours_per_day
    end

    # because we provide time for non-billable activities like SPACE
    def baseline_nonbillable_ratio
      BASELINE_TARGET_HOURS_PER_PERSON / AVAILABLE_HOURS_PER_PERSON
    end
    
    def net_available_hours
      employee.billable_target_ratio * available_hours.to_f
    end

    def target_hours
      employee.billable_target_ratio * available_hours.to_f * baseline_nonbillable_ratio
    end

    def hours_billed
      employee_time_entries.sum(&:rounded_hours).round(2)
    end

    def variance
      hours_billed - target_hours
    end

    def utilization
      (hours_billed / available_hours) * 100
    end

    def not_active?
      available_hours <= 0
    end

    private

    def employee_time_entries
      @employee_time_entries ||= time_entries.where(team_member_id: employee.id)
    end    
  end
end
