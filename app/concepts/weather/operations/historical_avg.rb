# frozen_string_literal: true

module Weather::Operations
  # Operations for getting historical average weather
  class HistoricalAvg < Trailblazer::Operation
    step :avg_temperature

    def avg_temperature(options, **)
      avg_temp = WeatherService.new.avg_temperature

      if avg_temp.nil?
        options[:result] = { error: 'Average temperature data not available' }
        options[:error_status] = 500
        return false
      end

      options[:result] = { avg_temperature_celsius: avg_temp }
      true
    end
  end
end
