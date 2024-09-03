# frozen_string_literal: true

module Weather::Operations
  # Operations for getting historical max weather
  class HistoricalMax < Trailblazer::Operation
    step :max_temperature

    def max_temperature(options, **)
      max_temp = WeatherService.new.max_temperature

      if max_temp.nil?
        options[:result] = { error: 'Max temperature data not available' }
        options[:error_status] = 500
        return false
      end

      options[:result] = { max_temperature_celsius: max_temp }
      true
    end
  end
end
