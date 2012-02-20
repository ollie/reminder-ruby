class EventsController
  def list(date)
    events = Event.near_events date

    table = Terminal::Table.new do |t|
      now = false
      t << [ { :value => I18n.t('title'), :colspan => 2, :alignment => :center } ]
      t << :separator
      events.each_with_index do |event, index|
        t << :separator if event.separators && index != 0
        t << [ I18n.l(event.date), event.name_with_kind ]
        t << :separator if event.separators && events[index + 1]
      end
    end

    puts table
  end
end