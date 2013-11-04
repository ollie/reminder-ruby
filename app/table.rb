class Table
    attr_accessor :events, :lines, :longest_line, :separator_line

    def config
        load_lines
    end

    def load_lines
        self.lines        = []
        self.longest_line = 0

        events.each do |event|
            line   = event_line(event)
            length = line.size

            self.longest_line = length if length > longest_line

            self.lines << { line: line, separators: event.separators }
        end
    end

    def event_line(event)
        line = "#{ event.localized_event_date } | #{ event.name_with_kind }"
        line
    end

    def draw
        headline 'Narozeniny, svátky, platby…'

        lines.each do |line|
            separator if line[:separators]
            puts line[:line]
            separator if line[:separators]
        end
    end

    def headline(text)
        puts text
        separator
    end

    def separator
        self.separator_line = '-' * longest_line if !separator_line
        puts separator_line
    end
end
