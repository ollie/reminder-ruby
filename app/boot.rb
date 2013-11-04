require File.expand_path('../event_controller', __FILE__)

class App
    def run
        run_controller
    end

    def run_controller
        controller = EventController.new
        controller.list
    end
end
