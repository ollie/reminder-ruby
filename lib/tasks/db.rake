namespace :g do
  desc 'Generate a new database migration'
  task :migration => :environment do
    now = Time.now.strftime '%Y%m%d%H%M%S'
    file_path = Root.join 'db', 'migrate', "#{ now }.rb"
    File.open(file_path, 'w') do |file|
      file << 'ActiveRecord::Schema.define do 
  create_table :things do |t|
    t.column :name, :string
  end
end'
      puts "Created #{ file_path }"
    end
  end
end

namespace :db do
  desc 'Run database migrations'
  task :migrate => :environment do
    Dir[ Root.join('db', 'migrate', '*') ].each do |migration_file|
      require migration_file
    end
  end

  desc 'Drop database'
  task :drop => :environment do
    sh "rm #{ Root.join('db', "#{ Env }.sqlite") }"
  end

  namespace :drop do
    desc 'Drop all databases'
    task :all => :environment do
      Reminder::ENVIRONMENTS.each do |environment|
        file_path = Root.join('db', "#{ environment }.sqlite")
        sh "rm #{ file_path }" if File.exists? file_path
      end
    end
  end

  desc 'Create database'
  task :create => :environment do
    sh "touch #{ Root.join('db', "#{ Env }.sqlite") }"
  end

  desc 'Drop, create and migrate database'
  task :recreate => [ :environment, :drop, :create, :migrate ]

  namespace :create do
    desc 'Create all databases'
    task :all => :environment do
      Reminder::ENVIRONMENTS.each do |environment|
        file_path = Root.join('db', "#{ environment }.sqlite")
        sh "touch #{ file_path }"
      end
    end
  end
end
