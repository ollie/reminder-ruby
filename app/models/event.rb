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

    events = Event.where(:month => months).order('month DESC, day DESC').all

    events.each do |event|
      modified_year = date.year

      #                                   vv <- now
      # Watch out for this: [ 10, 11, 12, 01, 02, 03, 04 ]
      # Or that:            [ 09, 10, 11, 12, 01, 02, 03 ]
      #                                   ^^
      index_of_current_month = months.index date.month
      first_half  = months[0..index_of_current_month]
      second_half = months[index_of_current_month..-1]

      if second_half.include?(event.month) && event.month < date.month
        modified_year += 1
      elsif first_half.include?(event.month) && event.month > date.month
        modified_year -= 1
      end

      # Debug
      if DEBUG
        modified_date = Date.new modified_year, event.month, event.day
        print date.year
        print " #{ '%+d' % (modified_year - date.year) }"
        print " #{ modified_date }"
        print " #{ event.inspect }"
        puts
      end

      event.date = Date.new modified_year, event.month, event.day
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
    "#{ self.name } #{ self.kind }"
  end
end