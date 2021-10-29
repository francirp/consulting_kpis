module Reporting
  class Filter
    attr_accessor :start_date, :end_date, :employment_type, :billable, :team_member

    def initialize(opts = {})
      @start_date = opts.fetch(:start_date, Date.today.beginning_of_year)
      @end_date = opts.fetch(:end_date, (Date.today - 1.month).end_of_month) 
      @employment_type = opts.fetch(:employment_type, 'all')
      @billable = opts.fetch(:billable, true)
      # @team_member = opts[:team_member] # for tailoring the report to a team member
    end

    def time_entries
      @time_entries ||= begin
        entries = TimeEntry
          .between(start_date, end_date)
          .where(billable: billable)
          .includes(:team_member)
          .joins(:team_member)        

        entries = entries.where.not(team_member_id: contractors.pluck(:id)) if employee_only?
        entries
      end
    end

    def time_entries_by_team_member_id
      @time_entries_by_team_member_id ||= time_entries.group_by(&:team_member_id)
    end

    def time_entries_by_client_id
      @time_entries_by_client_id ||= time_entries.group_by(&:client_id)
    end

    def invoices_by_client_id
      @invoices_by_client_id ||= invoices.group_by(&:client_id)
    end     

    # def team_member_time_entries
    #   time_entries.where(team_member_id: team_member.id)
    # end

    # def clients
    #   result = team_member.present? ? @team_member.clients : Client.all
    #   result.order("name ASC")
    # end

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
    
    # def team_member_total_hours
    #   100
    #   # @team_member_total_hours ||= team_member_time_entries.sum(:rounded_hours)
    # end    
    # def cost_by_team_member
    #   team_member_ids = time_entries.pluck(:team_member_id).uniq
    #   team_members = TeamMember.where(id: team_member_ids)
      
    #   hash = {}
    #   team_members.each do |team_member|
    #     if team_member.is_contractor?
    #       cost = time_entries.find_all { |t| t.team_member_id == team_member.id }.sum(&:rounded_hours) * team_member.cost_per_hour
    #     else
    #       days = days_in_period_for_team_member(team_member)
    #       cost = team_member.cost_per_hour * (days/365.0) * Reporting::EmployeeKeyMetrics::BASELINE_TARGET_HOURS_PER_PERSON
    #     end
    #     hash[team_member.id] = cost
    #   end
    #   hash
    # end
  end
end