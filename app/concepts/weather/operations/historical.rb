# frozen_string_literal: true

module Weather::Operations
  # Operations for getting historical weather
  class Historical < Trailblazer::Operation
    step :weather_data

    def weather_data(options, **)
      historical_data = WeatherService.new.historical

      if historical_data.nil?
        options[:result] = { error: 'Historical weather data not available' }
        options[:error_status] = 500
        return false
      end

      options[:result] = { hourly_temperatures: historical_data[:hourly_temperatures] }
      true
    end
  end
end
