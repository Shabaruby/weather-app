# frozen_string_literal: true

module Entities
  # Entity for HistoricalMinWeather
  class HistoricalMinWeatherEntity < Grape::Entity
    expose :min_temperature_celsius,
           documentation: { type: 'float', desc: 'minimum temperature for last 24 hours in celsius' }
  end
end
