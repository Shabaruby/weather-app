# frozen_string_literal: true

# HistoricalTemperature
class HistoricalTemperature < ApplicationRecord
  validates :temperature_celsius, presence: true
  validates :recorded_at, presence: true, uniqueness: true
end
