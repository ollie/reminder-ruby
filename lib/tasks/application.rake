task :default => :run

# Load application environment
task :environment do
  require './config/environment'
end

desc 'Run the application'
task :run => :environment do
  date = Date.today
  #date = Date.new 2012, 2, 2
  EventsController.new.list date
end

desc 'Start the console'
task :c => :environment do
  require 'pry'
  verbose false do
    sh "pry -r ./config/environments/#{ Env }"
  end
end
