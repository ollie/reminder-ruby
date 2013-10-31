require './config/environment'

date = Date.today
#date = Date.new 2012, 2, 2
EventsController.new.list date
