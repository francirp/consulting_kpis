module AsanaSync
  class SyncTasks
    attr_reader :team_member, :start_date

    def initialize(start_date)
      @start_date = start_date || Date.today - 1.week      
    end

    def call
      asana_team_members = TeamMember.where.not(asana_id: nil)
      asana_team_members.each do |team_member|
        puts "syncing tasks for #{team_member.email}"
        AsanaSync::SyncTasksForTeamMember.new(team_member, start_date)
      end
    end
  end
end