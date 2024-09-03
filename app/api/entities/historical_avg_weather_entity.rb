# frozen_string_literal: true

module Entities
  # Entity for HistoricalAvgWeather
  class HistoricalAvgWeatherEntity < Grape::Entity
    expose :avg_temperature_celsius,
           documentation: { type: 'float', desc: 'average temperature for last 24 hours in celsius' }
  end
end
