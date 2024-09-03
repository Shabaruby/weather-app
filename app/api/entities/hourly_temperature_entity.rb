# frozen_string_literal: true

module Entities
  # Entity for HourlyTemperature
  class HourlyTemperatureEntity < Grape::Entity
    expose :recorded_at, documentation: { type: 'string', desc: 'time of the temperature for last 24 hours' }
    expose :temperature_celsius, documentation: { type: 'float', desc: 'temperature for last 24 hours in celsius' }
  end
end
