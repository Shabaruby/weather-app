# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Weather::Operations::HistoricalAvg' do
  describe '#call' do
    subject(:operation_call) { Weather::Operations::HistoricalAvg.call }

    let(:weather_service) { instance_double(WeatherService) }

    before do
      allow(WeatherService).to receive(:new).and_return(weather_service)
    end

    context 'when average temperature data is available' do
      let(:avg_temp) { 15.2 }

      before do
        allow(weather_service).to receive(:avg_temperature).and_return(avg_temp)
      end

      it do
        expect(operation_call.success?).to be true
        expect(operation_call[:result][:avg_temperature_celsius]).to eq(15.2)
      end
    end

    context 'when average temperature data is not available' do
      before do
        allow(weather_service).to receive(:avg_temperature).and_return(nil)
      end

      it do
        expect(operation_call.success?).to be false
        expect(operation_call[:result][:error]).to eq('Average temperature data not available')
        expect(operation_call[:error_status]).to eq(500)
      end
    end
  end
end
