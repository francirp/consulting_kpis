class Harvest::HarvestProject < Harvest::Wrapper

  attr_reader :project_id, :project, :start_date, :end_date

  def rounded_hours
    @rounded_hours ||= hours.map { |hour| roundup(hour) }
  end

  def total_hours
    @total_hours ||= rounded_hours.sum
  end

  def harvest_time_entries
    @harvest_time_entries ||= harvest.reports.time_by_project(project, start_date, end_date)
  end

  def billable_harvest_time_entries
    @billable_harvest_time_entries ||= harvest.reports.time_by_project(project, start_date, end_date, billable: true)
  end

  def non_billable_harvest_time_entries
    @non_billable_harvest_time_entries ||= harvest.reports.time_by_project(project, start_date, end_date, billable: false)
  end

  def hours
    @hours ||= harvest_time_entries.map(&:hours)
  end

  def create
    local_project = ::Project.find_by_harvest_id(project.id) || ::Project.create(to_h)

    billable_harvest_time_entries.each do |harvest_time_entry|
      find_or_create_entry(local_project, harvest_time_entry, true)
    end

    non_billable_harvest_time_entries.each do |harvest_time_entry|
      find_or_create_entry(local_project, harvest_time_entry, false)
    end
  end

  def find_or_create_entry(local_project, harvest_time_entry, billable)
    time_entry = local_project.time_entries.find_by_harvest_id(harvest_time_entry.id) || local_project.time_entries.build
    puts "creating or updating time entry with harvest id: #{time_entry.harvest_id}"
    converter = Harvest::HarvestTimeEntry.new(entry: harvest_time_entry, billable: billable)
    time_entry.assign_attributes(converter.to_h)
    if time_entry.save
      puts "successfully saved #{time_entry.id} time entry for #{time_entry.harvest_id} harvest id"
    else
      puts "error saving time entry #{time_entry.harvest_id} harvest id: #{time_entry.errors.full_messages.join}"
    end
  end

  private

    def after_init(args = {})
      @project_id = args[:project_id]
      @project = projects.detect {|p| p.id == @project_id}
      @start_date = args.fetch(:start_date, Date.today.beginning_of_year)
      @end_date = args.fetch(:end_date, Date.today.end_of_year)
    end

    def required_fields
      super + [:project_id]
    end

    def to_h
      {
        harvest_id: project.id,
        name: project.name,
        harvest_client_id: project.client_id,
        hourly_rate: project.hourly_rate,
        hourly: project.hourly_rate.present?
      }
    end

end
