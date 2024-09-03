# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Weather::Operations::HistoricalMin' do
  describe '#call' do
    subject(:operation_call) { Weather::Operations::HistoricalMin.call }

    let(:weather_service) { instance_double(WeatherService) }

    before do
      allow(WeatherService).to receive(:new).and_return(weather_service)
    end

    context 'when min temperature data is available' do
      let(:min_temp) { -5.4 }

      before do
        allow(weather_service).to receive(:min_temperature).and_return(min_temp)
      end

      it do
        expect(operation_call.success?).to be true
        expect(operation_call[:result][:min_temperature_celsius]).to eq(-5.4)
      end
    end

    context 'when min temperature data is not available' do
      before do
        allow(weather_service).to receive(:min_temperature).and_return(nil)
      end

      it do
        expect(operation_call.success?).to be false
        expect(operation_call[:result][:error]).to eq('Min temperature data not available')
        expect(operation_call[:error_status]).to eq(500)
      end
    end
  end
end
