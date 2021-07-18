module Reporting
  class KeyMetrics
    POTENTIAL_HOURS_PER_YEAR_PER_PERSON = 1572
    attr_reader :start_date, :end_date, :employment_type, :billable

    def initialize(opts = {})
      @start_date = opts.fetch(:start_date, Date.today.beginning_of_year)
      @end_date = opts.fetch(:end_date, (Date.today - 1.month).end_of_month) 
      @employment_type = opts.fetch(:employment_type, 'all')
      @billable = opts.fetch(:billable, true)
    end
    
    def hours_billed
      time_entries.sum(:rounded_hours).round(2)
    end

    def revenue
      invoices.sum(:amount).round(2)
    end

    def effective_rate
      revenue / hours_billed
    end

    def hours_by_employee
      array = employees.map do |employee|
        hash = {}
        hash[:employee] = employee
        hash[:available_hours] = employee.available_hours(start_date, end_date)
        hash[:hours_billed] = employee.hours_billed(start_date, end_date)
        hash[:variance] = hash[:hours_billed] - hash[:available_hours]
        hash[:utilization] = (hash[:hours_billed] / hash[:available_hours]) * 100
        hash
      end
      array.sort_by { |hash| hash[:variance] }
    end

    def utilization
      hours_billed / available_hours_of_employees
    end

    def available_hours_of_employees
      hours_by_employee.sum do |employee_hash|
        employee_hash[:available_hours]
      end
    end
    
    def hours_variance
      hours_billed - available_hours_of_employees
    end

    private

    def employee_only?
      employment_type.downcase == 'employee'
    end

    def invoices
      @invoices ||= begin
        Invoice.between(start_date, end_date).where(is_retainer: false)
      end
    end

    def time_entries
      @time_entries ||= begin
        entries = TimeEntry
          .between(start_date, end_date)
          .where(billable: billable)          

        entries = entries.where.not(team_member_id: contractors.pluck(:id)) if employee_only?
        entries
      end
    end

    def contractors
      TeamMember.contractors
    end

    def employees
      TeamMember.employees
    end
  end
end