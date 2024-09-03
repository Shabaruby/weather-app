# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Weather::Operations::ByTime' do
  describe '#call' do
    subject(:operation_call) { Weather::Operations::ByTime.call(timestamp:) }

    let(:weather_service) { instance_double(WeatherService) }
    let(:timestamp) { Time.now.to_i }

    before do
      allow(WeatherService).to receive(:new).and_return(weather_service)
    end

    context 'when temperature data for the given timestamp is available' do
      let(:temperature) { 22.5 }

      before do
        allow(weather_service).to receive(:temperature_by_time).with(timestamp).and_return(temperature)
      end

      it do
        expect(operation_call.success?).to be true
        expect(operation_call[:result][:temperature_celsius]).to eq(temperature)
      end
    end
  end
end
