# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::HistoricalMaxWeatherEntity do
  subject { entity_as_json(described_class.represent(historical_max_weather)) }

  let(:historical_max_weather) do
    { max_temperature_celsius: 15.5 }
  end

  let(:data_expected) do
    {
      max_temperature_celsius: 15.5
    }
  end

  it { is_expected.to eq data_expected }
end
