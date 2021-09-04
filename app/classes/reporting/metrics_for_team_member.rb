module Reporting
  class MetricsForTeamMember
    POTENTIAL_HOURS_PER_YEAR_PER_PERSON = 1300    
    attr_reader :team_member, :timeframe_start_date, :timeframe_end_date, :available_hours

    def initialize(team_member, args = {})
      @team_member = team_member
      @timeframe_start_date = args.fetch(:timeframe_start_date, Date.new(2012,1,1))
      @timeframe_end_date = args.fetch(:timeframe_end_date, Date.today)
      @available_hours = calculate_available_hours
    end

    def calculate_available_hours
      return 0 unless team_member.start_date
      return 0 if team_member.start_date > timeframe_end_date # employee started after this reporting period
      return 0 if team_member.end_date && team_member.end_date < timeframe_start_date # employee ended before this reporting period
      team_member_start = [timeframe_start_date, team_member.start_date].max # because an employee can start before the reporting period
      # TODO: add accurate end date for each team member
      team_member_end = [timeframe_end_date, team_member.end_date].min # employee can end in the middle of this reporting period.
      days = (team_member_end - team_member_start).to_i
      potential_hours_per_day = POTENTIAL_HOURS_PER_YEAR_PER_PERSON/365    
      days * potential_hours_per_day
    end

    def target_hours
      available_hours * team_member.target_billable_ratio
    end

    def target_billable_ratio    
      team_member.target_billable_ratio
    end

    def actual_billable_ratio
      hours_billed / available_hours
    end

    def variance_to_target_ratio
      actual_billable_ratio - target_billable_ratio
    end

    def hours_billed
      team_member.time_entries.billable.between(timeframe_start_date, timeframe_end_date).sum(:rounded_hours)
    end
    
    def variance_to_target_hours
      target_hours - hours_billed
    end
  end
end