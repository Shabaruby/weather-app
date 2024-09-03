require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1h' do
  WeatherService.new.fetch_and_save_historical_data
end
