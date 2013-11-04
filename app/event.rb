class Event
    attr_accessor :id, :show, :birthday, :nameday, :payment, :year, :month, :day, :name, :event_date, :separators

    def self.from_row(row)
        event = Event.new

        event.id         = row['id']
        event.show       = row['show']
        event.birthday   = row['birthday']
        event.nameday    = row['nameday']
        event.payment    = row['payment']
        event.year       = row['year']
        event.month      = row['month']
        event.day        = row['day']
        event.name       = row['name']
        event.separators = false

        event
    end

    def self.today
        event = Event.new

        event.birthday   = false
        event.nameday    = false
        event.payment    = false
        event.name       = 'Dnes'
        event.event_date = Date.today
        event.separators = true

        event
    end

    def localized_event_date
        event_date.strftime('%d. %m. %Y')
    end

    def name_with_kind
        name = self.name
        name = "#{ name } #{ kind }" if kind

        if birthday
            years = Date.today.year - year
            name  = "#{ name } (#{ years })"
        end

        name
    end

    def kind
        if birthday
            'narozeniny'
        elsif nameday
            'svátek'
        elsif payment
            'platba'
        end
    end

    # We need to set the event date for sorting. There is a problem though,
    # we cannot simply set the current year for all events.
    #
    # We locate current month in the range and split it in two parts.
    # We then take the event month and ask a few questions:
    #
    # If the month is in the left part and is higher than the current month,
    # it means we are looking at the end of the previous year and we have
    # to decrement the year by one.
    #
    # If, however, the month is in the right part and is lower than the current month,
    # we are looking at the start of the next year and we have to increment it by one.
    #
    #                  event -> vv      vv <- current month
    # Watch out for this: [ 10, 11, 12, 01, 02, 03, 04 ]
    # Or that:            [ 09, 10, 11, 12, 01, 02, 03 ]
    #                  current month -> ^^  ^^ <- event
    def set_event_date(months, date)
        event_year = date.year

        index_of_current_month = months.index(date.month)

        left_part  = months[0..index_of_current_month]
        right_part = months[index_of_current_month..-1]

        if right_part.include?(month) && month < date.month
            event_year += 1
        elsif left_part.include?(month) && month > date.month
            event_year -= 1
        end

        self.event_date = Date.new(event_year, month, day)
    end
end
