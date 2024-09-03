# frozen_string_literal: true

# Job for fetching and saving historical weather data
class HistoricalJob < ApplicationJob
  queue_as :default

  def perform
    WeatherService.new.fetch_and_save_historical_data_sync
  end
end
