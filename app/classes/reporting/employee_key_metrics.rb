module Reporting
  class EmployeeKeyMetrics
    AVAILABLE_HOURS_PER_PERSON = 1572.0
    BASELINE_TARGET_HOURS_PER_PERSON = 1300.0

    attr_reader :filter, :employee, :employee_time_entries
    delegate :time_entries, :start_date, :end_date, to: :filter

    def initialize(filter, employee, opts = {})
      @filter = filter
      @employee = employee
      @employee_time_entries = opts.fetch(:time_entries, set_employee_time_entries)
    end

    def available_hours
      days = filter.days_in_period_for_team_member(employee)
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

    def set_employee_time_entries
      time_entries.where(team_member_id: employee.id)
    end    
  end
end
