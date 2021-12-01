module Reporting
  class Filter
    extend Memoist
    attr_accessor :start_date, :end_date, :employment_type, :billable

    def initialize(opts = {})
      @start_date = opts.fetch(:start_date, Date.today.beginning_of_year)
      @end_date = opts.fetch(:end_date, (Date.today - 1.month).end_of_month) 
      @employment_type = opts.fetch(:employment_type, 'all')
      @billable = opts.fetch(:billable, true)
    end

    def time_entries
      entries = TimeEntry
        .between(start_date, end_date)
        .where(billable: billable)
        .includes(:team_member)
        .joins(:team_member)        

      entries = entries.where.not(team_member_id: contractors.pluck(:id)) if employee_only?
      entries
    end
    memoize :time_entries    

    def completed_tasks
      tasks = AsanaTask
        .completed_between(start_date, end_date)
        .includes(:team_member)
        .joins(:team_member)

      tasks.where.not(team_member_id: contractors.pluck(:id)) if employee_only?
      tasks
    end
    memoize :completed_tasks 

    def time_entries_by_team_member_id
      @time_entries_by_team_member_id ||= time_entries.group_by(&:team_member_id)
    end

    def completed_tasks_by_team_member_id
      @completed_tasks_by_team_member_id ||= completed_tasks.group_by(&:team_member_id)
    end    

    def time_entries_by_client_id
      @time_entries_by_client_id ||= time_entries.group_by(&:client_id)
    end

    def completed_tasks_by_client_id
      @completed_tasks_by_client_id ||= completed_tasks.group_by(&:client_id)
    end 

    def invoices_by_client_id
      @invoices_by_client_id ||= invoices.group_by(&:client_id)
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

    def days_in_period_for_team_member(member)
      return 0 unless member.start_date
      return 0 if member.start_date > end_date # employee started after this reporting period
      return 0 if member.end_date && member.end_date < start_date # employee ended before this reporting period
      member_start = [start_date, member.start_date].compact.max # because an employee can start before the reporting period
      # TODO: add accurate end date for each team member
      member_end = [end_date, member.end_date].compact.min # employee can end in the middle of this reporting period.
      days = (member_end - member_start).to_i + 1
    end
  end
end