desc "This task is called by the Heroku scheduler add-on"
task :refresh_harvest_data => :environment do
  puts "pulling clients"
  HarvestSync::PullClients.new.call
  puts "pulling projects"
  HarvestSync::PullProjects.new.call
  puts "pulling invoices"
  HarvestSync::PullInvoices.new.call
  puts "pulling time entries"
  HarvestSync::PullTimeEntries.new.call
  puts "exporting data to google sheets"

  hours_updater = ExportData::ToGoogleSheets::Hours.new
  hours_updater.update

  # TODO: leverage DB instead of Harvest API when pushing invoices to Google Sheets
  invoice_updater = ExportData::ToGoogleSheets::Invoices.new 
  invoice_updater.update

  puts "done."
end

task :refresh_invoices => :environment do
  puts 'starting invoice updater...'
  invoice_updater = ExportData::ToGoogleSheets::Invoices.new
  invoice_updater.update
  puts 'done.'
end

task :push_hours => :environment do
  puts "exporting data to google sheets"
  hours_updater = ExportData::ToGoogleSheets::Hours.new
  hours_updater.update

  puts "done."
end

task :refresh_events => :environment do
  puts "pulling event data and pushing to google sheets"
  events_updater = ExportData::ToGoogleSheets::Events.new
  events_updater.update

  puts "done."
end

task :pull_budget_amounts => :environment do
  puts "pulling monthly budget amounts and storing in database"
  PullBudgetAmounts.new.call
  ExportData::ToGoogleSheets::DailyForecasts.new.update
  puts "done."
end