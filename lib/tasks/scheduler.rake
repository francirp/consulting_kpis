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
  s = ExportData::ToGoogleSheets.new
  s.delay.update
  puts "done."
end
