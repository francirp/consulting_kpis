namespace :db do
  desc "pulls Heroku DB down locally"
  task :restore_from_prod => :environment do
    raise "This is only allowed in development environment" unless Rails.env.development?
    Rake::Task["db:drop"].invoke
    cmd = "heroku pg:pull DATABASE_URL consulting_kpis_dev"
    puts cmd
    system cmd
    Rake::Task["db:migrate"].invoke
  end
end