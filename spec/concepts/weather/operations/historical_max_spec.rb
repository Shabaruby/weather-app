# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Weather::Operations::HistoricalMax' do
  describe '#call' do
    subject(:operation_call) { Weather::Operations::HistoricalMax.call }

    let(:weather_service) { instance_double(WeatherService) }

    before do
      allow(WeatherService).to receive(:new).and_return(weather_service)
    end

    context 'when max temperature data is available' do
      let(:max_temp) { 35.6 }

      before do
        allow(weather_service).to receive(:max_temperature).and_return(max_temp)
      end

      it do
        expect(operation_call.success?).to be true
        expect(operation_call[:result][:max_temperature_celsius]).to eq(35.6)
      end
    end

    context 'when max temperature data is not available' do
      before do
        allow(weather_service).to receive(:max_temperature).and_return(nil)
      end

      it do
        expect(operation_call.success?).to be false
        expect(operation_call[:result][:error]).to eq('Max temperature data not available')
        expect(operation_call[:error_status]).to eq(500)
      end
    end
  end
end
