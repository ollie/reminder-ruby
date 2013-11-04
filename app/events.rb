require File.expand_path('../event', __FILE__)

class Events
    def initialize
        @db = SQLite3::Database.new('db/events.sqlite')
        @db.results_as_hash = true
    end

    def near_today
        date = Date.today
        # date = Date.new(2013, 11, 1)
        events = near_date(date)
        events
    end

    def near_date(date)
        months = (-1..2).map do |delta_month|
            month = date.month + delta_month

            if month > 12
                month -= 12
            elsif month < 1
                month += 12
            end

            month
        end

        events = []

        @db.execute(
            '
                SELECT *
                FROM "events"
                WHERE
                    "show" = 1
                    AND "month" IN (%s)
            ' % join(months)
        ).each do |row|
            event = Event.from_row(row)
            event.set_event_date(months, date)
            events << event
        end

        events << Event.today
        events.sort! { |event_a, event_b| event_b.event_date <=> event_a.event_date }

        events
    end

    def join(list)
        list.join(', ')
    end
end
