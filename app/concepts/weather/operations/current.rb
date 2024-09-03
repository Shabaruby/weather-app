# frozen_string_literal: true

module Weather::Operations
  # Operations for getting current weather
  class Current < Trailblazer::Operation
    step :current_weather

    def current_weather(options, **)
      weather_data = WeatherService.new.call

      if weather_data.nil?
        options[:result] = { error: 'Weather data not available' }
        options[:error_status] = 500
        return false
      end

      options[:result] = { temperature_celsius: weather_data[:temperature_celsius] }
      true
    end
  end
end
