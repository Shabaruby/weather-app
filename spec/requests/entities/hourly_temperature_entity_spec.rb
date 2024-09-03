# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::HourlyTemperatureEntity do
  subject { entity_as_json(described_class.represent(historical_temperature)) }

  let(:historical_temperature) { create(:historical_temperature, temperature_celsius: 20.0) }

  let(:data_expected) do
    {
      temperature_celsius: '20.0',
      recorded_at: historical_temperature.recorded_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
    }
  end

  it { is_expected.to eq data_expected }
end
