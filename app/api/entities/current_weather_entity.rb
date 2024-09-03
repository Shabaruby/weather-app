# frozen_string_literal: true

module Entities
  # Entity for CurrentWeather
  class CurrentWeatherEntity < Grape::Entity
    expose :temperature_celsius, documentation: { type: 'integer', format: 'float', desc: 'temperature in celsius' }
  end
end
