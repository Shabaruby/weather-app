# frozen_string_literal: true

module Weather::Operations
  # Operations for getting historical min weather
  class HistoricalMin < Trailblazer::Operation
    step :min_temperature

    def min_temperature(options, **)
      min_temp = WeatherService.new.min_temperature

      if min_temp.nil?
        options[:result] = { error: 'Min temperature data not available' }
        options[:error_status] = 500
        return false
      end

      options[:result] = { min_temperature_celsius: min_temp }
      true
    end
  end
end
