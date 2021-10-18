module Reporting
  class Filter
    attr_accessor :start_date, :end_date, :employment_type, :billable

    def initialize(opts = {})
      @start_date = opts.fetch(:start_date, Date.today.beginning_of_year)
      @end_date = opts.fetch(:end_date, (Date.today - 1.month).end_of_month) 
      @employment_type = opts.fetch(:employment_type, 'all')
      @billable = opts.fetch(:billable, true)
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

    def employee_only?
      employment_type.downcase == 'employee'
    end

    def invoices
      @invoices ||= begin
        Invoice.between(start_date, end_date).where(is_retainer: false)
      end
    end

    def contractors
      @contractors ||= TeamMember.contractors
    end

    def employees
      @employees ||= TeamMember.employees
    end    
  end
end