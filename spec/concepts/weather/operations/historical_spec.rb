# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Weather::Operations::Historical' do
  describe '#call' do
    subject(:operation_call) { Weather::Operations::Historical.call }

    let(:weather_service) { instance_double(WeatherService) }

    before do
      allow(WeatherService).to receive(:new).and_return(weather_service)
    end

    context 'when historical weather data is available' do
      let(:historical_data) { { hourly_temperatures: [12.3, 14.5, 10.0] } }

      before do
        allow(weather_service).to receive(:historical).and_return(historical_data)
      end

      it do
        expect(operation_call.success?).to be true
        expect(operation_call[:result][:hourly_temperatures]).to eq([12.3, 14.5, 10.0])
      end
    end

    context 'when historical weather data is not available' do
      before do
        allow(weather_service).to receive(:historical).and_return(nil)
      end

      it do
        expect(operation_call.success?).to be false
        expect(operation_call[:result][:error]).to eq('Historical weather data not available')
        expect(operation_call[:error_status]).to eq(500)
      end
    end
  end
end
