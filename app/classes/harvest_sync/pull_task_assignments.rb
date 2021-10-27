module HarvestSync
  class PullTaskAssignments
    def intialize;end

    def call
      array = []
      projects = Project.all.group_by(&:harvest_id)
      tasks = Task.all.group_by(&:harvest_id)
      harvesting_client.projects.each do |project|
        puts "Project: #{project.name}"
        project.task_assignments.each do |task_assignment|
          hash = {
            harvest_id: task_assignment.id,
            project_id: projects[task_assignment.project.id].first.id,
            task_id: tasks[task_assignment.task.id].first.id,
            is_active: task_assignment.is_active,
            created_at: Time.now,
            updated_at: Time.now,
          }
          array << hash
        end
      end
      TaskAssignment.upsert_all(array, unique_by: :harvest_id)
    end
  end
end