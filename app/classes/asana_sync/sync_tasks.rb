module AsanaSync
  class SyncTasks
    attr_reader :start_date

    def initialize(start_date)
      @start_date = start_date || Date.today - 1.week      
    end

    def call
      asana_projects = AsanaProject.all
      asana_projects.each do |project|
        puts "syncing tasks for #{project.name}"
        AsanaSync::SyncTasksForProject.new(project, start_date).call
      end
    end
  end
end