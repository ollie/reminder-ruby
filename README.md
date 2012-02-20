# Reminder
This is a simple Ruby (1.9.3+) command-line application to display upcoming and past events like birthdays, namedays and payments.

This isn't really an application, it's just a bunch of scripts to print out events. It doesn't let you do anything. Data manipulation is done via editing tha data.rake file and reloading the data from scratch (i.e. running `rake db:recreate db:data:load`).

If you have a Mac, it can be hooked into [GeekTool](http://itunes.apple.com/cz/app/geektool/id456877552?mt=12) and displayed on your desktop.

## Installation
    $ git clone git://github.com/ollie/reminder.git      # Clone this repo
    $ cd reminder                                        # Get in
    $ bundle install                                     # Install required RubyGems
    $ cp config/database.yml.example config/database.yml # Set your database connections
    $ rake db:create db:migrate                          # Create and migrate a SQLite3 database
    $ cp lib/tasks/data.rake.sample lib/tasks/data.rake  # Prepare your data file
    # Edit your data file lib/tasks/data.rake
    $ rake db:data:load                                  # Load your data into database
    $ rake run                                           # Run the application

## Tasks
    $ rake -T
    rake c              # Start the console
    rake db:create      # Create database
    rake db:create:all  # Create all databases
    rake db:data:load   # Load data into database
    rake db:drop        # Drop database
    rake db:drop:all    # Drop all databases
    rake db:migrate     # Run database migrations
    rake db:recreate    # Drop, create and migrate database
    rake g:migration    # Generate a new database migration
    rake run            # Run the application
    rake test           # Run tests

## Running the application
    $ cd path/to/your/cloned/repo
    $ rake run
    +----------------+-----------------------+
    |     Birthdays, namedays, payments…     |
    +----------------+-----------------------+
    | 2012-04-25     | Theo nameday          |
    | 2012-03-13     | Vanessa nameday       |
    | 2012-03-12     | hosting payment       |
    | 2012-03-11     | Something payment     |
    | 2012-02-27     | Cousin Cliff birthday |
    +----------------+-----------------------+
    | 2012-02-20     | Today                 |
    +----------------+-----------------------+
    | 2012-01-07     | Cousin Clair birthday |
    +----------------+-----------------------+

## Editing your data
Open `lib/tasks/data.rake` in your text editor and modify it at your will. This is sample data:

    # encoding: utf-8

    namespace :db do
      namespace :data do

        desc 'Load data into database'
        task :load => :environment do
          events = [
            # Namedays
            { :month => 4,  :day => 25,  :nameday => true,  :name => 'Theo' },
            { :month => 3,  :day => 13,  :nameday => true,  :name => 'Vanessa' },

            # Birthdays
            { :month => 2,  :day => 27, :birthday => true, :name => 'Cousin Cliff', :year => 1980 },
            { :month => 1,  :day => 7,  :birthday => true, :name => 'Cousin Clair', :year => 1990 },

            # Payments
            { :month => 3,  :day => 12, :payment => true,  :name => 'hosting' },
            { :month => 3,  :day => 11, :payment => true,  :name => 'Something' },
          ]

          events.each do |event_hash|
            event = Event.new event_hash
            event.save
            p event
          end
        end

      end
    end

And then run `rake db:recreate db:data:load` to take effect.

## Changing the locale
Currently supported locales are :en and :cs, no problem adding more. Just edit the `config/application.rb`:

    module Reminder
      ...
      LOCALE = :cs # :en, :cs
      ...
    end

And run the application

    $ rake run
    +--------------+-------------------------+
    |      Narozeniny, svátky, platby…       |
    +--------------+-------------------------+
    | 25. 04. 2012 | Theo svátek             |
    | 13. 03. 2012 | Vanessa svátek          |
    | 12. 03. 2012 | hosting platba          |
    | 11. 03. 2012 | Something platba        |
    | 27. 02. 2012 | Cousin Cliff narozeniny |
    +--------------+-------------------------+
    | 20. 02. 2012 | Dnes                    |
    +--------------+-------------------------+
    | 07. 01. 2012 | Cousin Clair narozeniny |
    +--------------+-------------------------+

## Gems used
    gem 'sqlite3'
    gem 'activerecord'
    gem 'pry'
    gem 'terminal-table'

## The MIT License (MIT)

Copyright © 2012 - Time.now.year Oldřich Vetešník

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.