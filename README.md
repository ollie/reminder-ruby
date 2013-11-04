# Reminder
This is a simple Ruby command-line application to display upcoming and past events like birthdays, namedays and payments. It looks two months ahead and one month back.

This isn't really an application, it's just a bunch of scripts to print out events. It doesn't let you do anything. Data manipulation is done via editing the `db/data.rb` file and reloading the data from scratch (i.e. running `ruby db/recreate.rb`).

If you have a Mac, it can be hooked into [GeekTool](http://itunes.apple.com/cz/app/geektool/id456877552?mt=12) and displayed on your desktop.

## Installation
    $ git clone git://github.com/ollie/reminder-ruby.git # Clone this repo
    $ cd reminder-ruby                                   # Get in
    $ cp db/data.rb.example db/data.rb                     # Prepare your data file
    # Edit your data file db/data.rb
    $ ruby db/recreate.rb                               # Load your data into database
    $ ./run.rb                                             # Run the application
    $ ruby run.rb                                       # Run the application alternatively

## Running the application
    $ cd path/to/reminder-ruby # You need to `cd` to the application directory so it finds the database file
    $ ./run.rb
