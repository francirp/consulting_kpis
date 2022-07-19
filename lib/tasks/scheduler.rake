desc "This task is called by the Heroku scheduler add-on"
task :refresh_weekly_harvest_data => :environment do
  start_date = Date.today - 8.days
  RefreshHarvestData.new(start_date).call
end

task :refresh_monthly_harvest_data => :environment do
  start_date = Date.today - 45.days
  RefreshHarvestData.new(start_date).call
end

task :refresh_asana_tasks => :environment do
  start_date = Date.today.beginning_of_year
  RefreshAsanaData.new(start_date).call
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

task :send_feedback_requests => :environment do
  puts "sending feedback requests"
  Contact.all_ready_for_feedback_request.each do |contact|
    contact.send_feedback_request
  end
end
