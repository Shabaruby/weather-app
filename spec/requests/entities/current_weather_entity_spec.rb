# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::CurrentWeatherEntity do
  subject { entity_as_json(described_class.represent(temperature)) }

  let(:temperature) { create(:temperature, temperature_celsius: 20.0) }

  let(:data_expected) do
    {
      temperature_celsius: '20.0'
    }
  end

  it { is_expected.to eq data_expected }
end
