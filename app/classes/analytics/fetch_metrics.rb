module Analytics
  class KeyMetrics
    attr_reader :start_date, :end_date, :employment_type, :billable

    def initialize(start_date, end_date, opts = {})
      @start_date = start_date
      @end_date = end_date
      @employment_type = opts[:employment_type]
      @billable = opts.fetch(:billable, true)
    end

    def time_entries
      @time_entries ||= begin
        TimeEntry
          .between(start_date, end_date)
          .where(billable: billable)
          .where.not(team_member_id: )
      end
    end

    def contractors
      TeamMember.contractors
    end
  end
end