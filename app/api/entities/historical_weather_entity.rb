# frozen_string_literal: true

module Entities
  # Entity for HistoricalWeather
  class HistoricalWeatherEntity < Grape::Entity
    expose :hourly_temperatures, using: Entities::HourlyTemperatureEntity
  end
end
