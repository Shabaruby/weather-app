# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::HistoricalAvgWeatherEntity do
  subject { entity_as_json(described_class.represent(historical_avg_weather)) }

  let(:historical_avg_weather) do
    { avg_temperature_celsius: 15.5 }
  end

  let(:data_expected) do
    {
      avg_temperature_celsius: 15.5
    }
  end

  it { is_expected.to eq data_expected }
end
