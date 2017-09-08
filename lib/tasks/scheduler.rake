desc "This task is called by the Heroku scheduler add-on"
task :refresh_harvest_data => :environment do
  h = Harvest::Pull.new
  puts "pulling clients"
  h.pull_clients
  puts "pulling projects"
  h.pull_projects
  puts "assigning clients to projects"
  h.assign_clients_to_projects
  puts "exporting data to google sheets"

  month_one = Date.today.strftime('%m')[0..2]
  month_two = (Date.today - 1.month).strftime('%m')[0..2]
  worksheets = [
    worksheets_by_month[month_one],
    worksheets_by_month[month_two],
  ]

  worksheets.each do |worksheet|
    ExportData::ToGoogleSheets::Hours.new(worksheet: )
  hours_updater =
  hours_updater.update

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
