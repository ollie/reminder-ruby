desc 'List all events'
task :list => :environment do
  Event.order('month, day').each do |event|
    puts "#{ event.kindofdate.strftime('%-d/%-m/%Y').ljust 10 } #{ event.name_with_kind }"
  end
end
