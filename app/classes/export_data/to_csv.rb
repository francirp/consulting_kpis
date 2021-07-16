class ExportData::ToCsv
  attr_reader :clients, :csv

  def initialize(args = {})
    @clients = args[:clients]
  end

  def to_csv
    CSV.generate do |csv|
      @csv = csv
      @csv << headers
      clients.each do |client|
        client.projects.each do |project|
          project_data(project)
        end
      end
    end
  end

  def headers
    %w(Client Project Year Month Week Hours Hourly\ Rate)
  end

  def project_data(project)
    data = []
    client = project.client
    project.entries_by_year_and_week.each do |year, weeks|
      weeks.each do |week, entries|
        rounded_hours = entries.sum(:rounded_hours).try(:round, 2)
        billable_amount = (project.hourly_rate || 0.00) * (project.rounded_hours || 0.00)
        @csv << [client.name, project.name, year, entries.first.spent_at.month, week, rounded_hours, project.hourly_rate]
      end
    end
    return data
  end
end
