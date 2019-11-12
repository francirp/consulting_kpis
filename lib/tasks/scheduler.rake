desc "This task is called by the Heroku scheduler add-on"
task :refresh_harvest_data => :environment do
  # run your code here
  h = Harvest::Pull.new
  puts "pulling clients"
  h.pull_clients
  puts "pulling projects"
  h.pull_projects
  puts "assigning clients to projects"
  h.assign_clients_to_projects
  puts "exporting data to google sheets"

  hours_updater = ExportData::ToGoogleSheets::Hours.new
  hours_updater.update

  invoice_updater = ExportData::ToGoogleSheets::Invoices.new
  invoice_updater.update

  events_updater = ExportData::ToGoogleSheets::Events.new
  events_updater.update

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
  puts "done."
end