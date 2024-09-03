# frozen_string_literal: true

module Entities
  # Entity for HistoricalMaxWeather
  class HistoricalMaxWeatherEntity < Grape::Entity
    expose :max_temperature_celsius,
           documentation: { type: 'float', desc: 'maximum temperature for last 24 hours in celsius' }
  end
end
