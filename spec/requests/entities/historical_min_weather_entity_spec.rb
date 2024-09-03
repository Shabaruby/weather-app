# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::HistoricalMinWeatherEntity do
  subject { entity_as_json(described_class.represent(historical_min_weather)) }

  let(:historical_min_weather) do
    { min_temperature_celsius: 15.5 }
  end

  let(:data_expected) do
    {
      min_temperature_celsius: 15.5
    }
  end

  it { is_expected.to eq data_expected }
end
