# Load the application
require File.expand_path('../application', __FILE__)

# Setup root path
Root = Pathname.new File.expand_path('../..', __FILE__)
Env = Reminder.environment ENV['APP_ENV']

# Initialize the application
Reminder.initialize!
