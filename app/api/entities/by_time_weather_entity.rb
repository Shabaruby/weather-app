# frozen_string_literal: true

module Entities
  # Entity for ByTimeWeather
  class ByTimeWeatherEntity < Grape::Entity
    expose :temperature_celsius,
           documentation: { type: 'float', desc: 'temperature in celsius for the given timestamp' }
  end
end
