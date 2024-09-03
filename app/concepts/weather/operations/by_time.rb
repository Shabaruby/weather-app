# frozen_string_literal: true

module Weather::Operations
  # Operations for getting weather by timestamp
  class ByTime < Trailblazer::Operation
    step :temperature_by_time

    def temperature_by_time(options, timestamp:, **)
      options['temperature'] = WeatherService.new.temperature_by_time(timestamp)

      temperature = options['temperature']
      options['result'] = if temperature
                            { temperature_celsius: temperature }
                          else
                            { error: 'Temperature not found for the given timestamp' }
                          end
    end
  end
end
