module Reporting
  class KeyMetrics
    POTENTIAL_HOURS_PER_YEAR_PER_PERSON = 1572
    attr_reader :filter
    delegate :start_date, :end_date, :employment_type, :billable,
             :time_entries, :contractors, :employees, :invoices, to: :filter

    def initialize(filter)
      @filter = filter
    end
    
    def hours_billed
      @hours_billed ||= time_entries.sum(:rounded_hours).round(2)
    end

    def revenue
      @revenue ||= invoices.sum(:amount).round(2)
    end

    def effective_rate
      revenue / hours_billed
    end

    def hours_by_employee
      array = employees.map do |employee|
        EmployeeKeyMetrics.new(
          filter,
          employee,
        )
      end
      array.reject! { |e| e.not_active? }
      array.compact.sort_by { |e| e.variance }
    end

    def utilization
      hours_billed / available_hours_of_employees
    end

    def available_hours_of_employees
      @available_hours_of_employees ||= begin
        hours_by_employee.sum do |employee_metrics|
          employee_metrics.available_hours
        end
      end
    end
    
    def target_hours_of_employees
      @target_hours_of_employees ||= begin
        hours_by_employee.sum do |employee_metrics|
          employee_metrics.target_hours
        end
      end
    end

    def net_available_hours_of_employees
      @net_available_hours_of_employees ||= begin
        hours_by_employee.sum do |employee_metrics|
          employee_metrics.net_available_hours
        end
      end
    end

    # target is 83%
    def net_utilization
      hours_billed / net_available_hours_of_employees
    end

    def target_hours_variance_percentage
      (hours_billed / target_hours_of_employees) - 1
    end

    def effective_rate_variance_percentage
      (effective_rate / 160.0) - 1
    end
    
    def hours_variance
      hours_billed - target_hours_of_employees
    end
  end
end