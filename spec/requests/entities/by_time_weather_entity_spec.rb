# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::ByTimeWeatherEntity do
  subject { entity_as_json(described_class.represent(historical_temperature)) }

  let(:historical_temperature) { create(:historical_temperature, temperature_celsius: 20.0) }

  let(:data_expected) do
    {
      temperature_celsius: '20.0'
    }
  end

  it { is_expected.to eq data_expected }
end
