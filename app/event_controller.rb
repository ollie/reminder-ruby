require File.expand_path('../events', __FILE__)
require File.expand_path('../table', __FILE__)

class EventController
    def list
        events = Events.new.near_today

        table = Table.new
        table.events = events
        table.config
        table.draw
    end
end
