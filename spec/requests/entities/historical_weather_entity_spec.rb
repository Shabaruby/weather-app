# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::HistoricalWeatherEntity do
  subject { entity_as_json(Entities::HistoricalWeatherEntity.represent(historical_weather)) }

  let(:historical_temperature) do
    create(:historical_temperature, temperature_celsius: 20.0, recorded_at: Time.zone.now)
  end

  let(:historical_weather) { { hourly_temperatures: [historical_temperature] } }

  let(:data_expected) do
    {
      hourly_temperatures: [
        {
          temperature_celsius: '20.0',
          recorded_at: historical_temperature.recorded_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        }
      ]
    }
  end

  it { is_expected.to eq data_expected }
end
