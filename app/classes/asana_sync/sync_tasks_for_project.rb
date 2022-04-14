module AsanaSync
  class SyncTasksForProject
    attr_reader :asana_project, :start_date

    def initialize(asana_project, opts = {})
      @asana_project = asana_project      
      @start_date = opts.fetch(:start_date) { Date.today - 1.week }   
    end

    def call
      puts "Syncing tasks for #{asana_project.name}"
      team_members = TeamMember.where.not(asana_id: nil).group_by(&:asana_id)

      keep_fetching = true
      offset_token = nil
      while keep_fetching
        service = AsanaApi::GetTasks.new(
          start_date,
          project_id: asana_project.asana_id,
          offset_token: offset_token
        )
        service.call
        return if service.data.blank? # no tasks for this project

        array = service.data.map do |task|
          hash = AsanaSync::TransformTask.new(task).call
          assignee_id = task.dig("assignee", "gid")
          team_member = team_members[assignee_id].try(:first)
          hash.merge!(
            team_member_id: team_member.try(:id),
            asana_project_id: asana_project.id,
          )
          hash
        end
        
        AsanaTask.upsert_all(array, unique_by: :asana_id)
        offset_token = service.response_offset_token
        keep_fetching = offset_token.present?
      end
      puts "Done syncing tasks for #{asana_project.name}"
    end
  end
end