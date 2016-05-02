class Harvest::Pull < Harvest::Wrapper

  attr_reader :start_date, :end_date

  def after_init(args = {})
    @start_date = args.fetch(:start_date, Date.today - 2.months)
    @end_date = args.fetch(:end_date, Date.today.end_of_year)
  end

  def pull_projects
    projects.each do |project|
      puts "creating or updating #{project.name}"
      harvest_project = Harvest::HarvestProject.new(project_id: project.id, start_date: start_date, end_date: end_date)
      harvest_project.create
    end
  end

  def pull_clients
    clients.each do |client|
      puts "creating or updating #{client.name}"
      harvest_client = Harvest::HarvestClient.new(client_wrapper: client)
      local_client = harvest_client.find_or_build
      local_client.assign_attributes(harvest_client.to_h)
      if local_client.save
        puts "successfully saved #{client.name}"
      else
        puts "error saving client #{local_client.harvest_id} harvest id: #{local_client.errors.full_messages.join}"
      end
    end
  end

  def assign_clients_to_projects
    ::Project.all.each do |project|
      client = ::Client.find_by_harvest_id(project.harvest_client_id)
      project.client_id = client.id
      project.save
    end
  end

  def pull_harvest_users

  end
end
