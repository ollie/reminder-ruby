class Event < ActiveRecord::Base
  DEBUG = ENV['DEBUG'].to_i == 1

  validates :month, :presence => true, :numericality => { :only_integer => true }
  validates :day, :presence => true, :numericality => { :only_integer => true }

  attr_accessor :date, :separators

  def self.near_events(date, range = -1..2)
    raw_months = range.map { |number| date.month + number }
    months = raw_months.map { |month| month + if month > 12 then -12 elsif month < 1 then +12 else 0 end }

    if DEBUG
      puts "range: #{ range }"
      puts "date:  #{ date }"
      puts "raw_months: [ #{ raw_months.map { |m| m.to_s.rjust(2, '0') }.join(', ') } ]"
      puts "months:     [ #{ months.map     { |m| m.to_s.rjust(2, '0') }.join(', ') } ]"
    end

    events = Event.where(:month => months).order('month DESC, day DESC')

    events.each do |event|
      event_year = date.year

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
      index_of_current_month = months.index date.month

      left_part  = months[0..index_of_current_month]
      right_part = months[index_of_current_month..-1]

      if right_part.include?(event.month) && event.month < date.month
        event_year += 1
      elsif left_part.include?(event.month) && event.month > date.month
        event_year -= 1
      end

      # Debug
      if DEBUG
        modified_date = Date.new event_year, event.month, event.day
        print date.year
        print " #{ '%+d' % (event_year - date.year) }"
        print " #{ modified_date }"
        print " #{ event.inspect }"
        puts
      end

      event.date = Date.new event_year, event.month, event.day
    end

    events << Event.new( :date => date, :name => I18n.t('today'), :separators => true )
    events.sort! { |event_a, event_b| event_b.date <=> event_a.date }
    events
  end

  def kind
    if self.birthday?
      I18n.t('birthday')
    elsif self.nameday?
      I18n.t('nameday')
    elsif self.payment?
      I18n.t('payment')
    end
  end

  def name_with_kind
    out = "#{ self.name } #{ self.kind }"
    out += " (#{ Time.now.year - self.year })" if self.birthday?
    out
  end

  def kindofdate
    Date.new (self.year || Time.now.year), self.month, self.day
  end
end
