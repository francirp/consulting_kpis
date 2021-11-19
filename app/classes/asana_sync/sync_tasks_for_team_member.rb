module AsanaSync
  class SyncTasksForTeamMember
    attr_reader :team_member, :start_date

    def initialize(team_member, opts = {})
      @team_member = team_member      
      @start_date = opts.fetch(:start_date) { Date.today - 1.week }   
    end

    def call
      # projects = AsanaProject.all.group_by(&:asana_id)

      keep_fetching = true
      offset_token = nil
      while keep_fetching
        service = AsanaApi::GetTasks.new(
          start_date,
          assignee_id: team_member.asana_id,
          offset_token: offset_token
        )
        service.call

        array = service.data.map do |task|
          hash = AsanaSync::TransformTask.new(task).call
          hash.merge(
            team_member_id: team_member.id,
            # project_id: projects[entry.dig('project', 'id')].first.id,
          )          
          binding.pry
            
          email = user["email"].try(:downcase)
          team_member = team_members[email].try(:first)
          puts email if team_member.nil?        
          next unless team_member # team member not in harvest, so skip
          ids << team_member.id
          { 
            id: team_member.id,
            asana_id: user["gid"],            
          }
        end.compact # compact to remove the nils from users not in harvest
        TeamMember.update(ids, array)
        offset_token = service.response_offset_token
        keep_fetching = offset_token.present?
      end
    end

    def transform_task(task)
      
    end
  end
end