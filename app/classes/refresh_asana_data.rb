class RefreshAsanaData
  attr_reader :start_date

  def initialize(start_date)
    @start_date = start_date
  end

  def call
    start_time = Time.now
    puts "pulling users"
    AsanaSync::SyncUsers.new.call
    puts "pulling projects"
    AsanaSync::SyncProjects.new.call
    puts "pulling tasks"
    asana_projects = AsanaProject.all
    asana_projects.each do |project|
      puts "pulling tasks for #{project.name}"
      AsanaSync::SyncTasksForProject.new(project, start_date: start_date).call
    end
    end_time = Time.now
    puts "Done. Sync finished in #{end_time - start_time}"
  end
end