class RefreshHarvestData
  attr_reader :start_date

  def initialize(start_date)
    @start_date = start_date
  end

  def call
    start_time = Time.now
    puts "pulling users"
    HarvestSync::CreateTeamMembers.new.call  
    puts "pulling clients"
    HarvestSync::PullClients.new.call
    puts "pulling projects"
    HarvestSync::PullProjects.new.call
    puts "pulling invoices"
    HarvestSync::PullInvoices.new.call
    puts "pulling time entries"
    HarvestSync::PullTimeEntries.new(start_date: start_date).call
    puts "exporting data to google sheets"

    TeamMember.all.each do |team_member|
      team_member.set_start_and_end_date
    end

    hours_updater = ExportData::ToGoogleSheets::Hours.new
    hours_updater.update

    # TODO: leverage DB instead of Harvest API when pushing invoices to Google Sheets
    invoice_updater = ExportData::ToGoogleSheets::Invoices.new 
    invoice_updater.update
    end_time = Time.now
    puts "Done. Sync finished in #{end_time - start_time}"
  end
end