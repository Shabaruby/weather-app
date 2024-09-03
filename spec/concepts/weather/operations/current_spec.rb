# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Weather::Operations::Current' do
  describe '#call' do
    subject(:operation_call) { Weather::Operations::Current.call }

    let(:weather_service) { instance_double(WeatherService) }

    before do
      allow(WeatherService).to receive(:new).and_return(weather_service)
    end

    context 'when weather data is available' do
      let(:data_expected) { { temperature_celsius: 22.5 } }

      before do
        allow(weather_service).to receive(:call).and_return(data_expected)
      end

      it do
        expect(operation_call.success?).to be true
        expect(operation_call[:result][:temperature_celsius]).to eq(22.5)
      end
    end

    context 'when weather data is not available' do
      before do
        allow(weather_service).to receive(:call).and_return(nil)
      end

      it do
        expect(operation_call.success?).to be false
        expect(operation_call[:result][:error]).to eq('Weather data not available')
        expect(operation_call[:error_status]).to eq(500)
      end
    end
  end
end
