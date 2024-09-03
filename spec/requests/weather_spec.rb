# frozen_string_literal: true

require 'rails_helper'
require 'vcr'

RSpec.describe 'Weather API', type: :request do
  describe 'GET /api/v1/weather/current' do
    before do
      create(:temperature, temperature_celsius: 27.5)
    end

    include_examples 'successful weather request', 'weather_current/success', '/api/v1/weather/current',
                     'temperature_celsius', '27.5'
  end

  describe 'historical weather' do
    let(:timestamp) { Time.zone.now.to_i }
    let(:recorded_at) { Time.zone.parse('2024-09-02T11:57:00.000Z') }

    before do
      create(:historical_temperature, temperature_celsius: 24.0, recorded_at:)
    end

    describe 'GET /api/v1/weather/historical' do
      it do
        VCR.use_cassette('weather_historical/success') do
          get '/api/v1/weather/historical'

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body['hourly_temperatures'].first).to eq(
            'temperature_celsius' => '24.0',
            'recorded_at' => '2024-09-02T11:57:00.000Z'
          )
        end
      end
    end

    describe 'GET /api/v1/weather/historical_max' do
      include_examples 'successful weather request', 'weather_historical_max/success',
                       '/api/v1/weather/historical_max', 'max_temperature_celsius', '24.0'
    end

    describe 'GET /api/v1/weather/historical_min' do
      include_examples 'successful weather request', 'weather_historical_min/success',
                       '/api/v1/weather/historical_min', 'min_temperature_celsius', '24.0'
    end

    describe 'GET /api/v1/weather/historical_avg' do
      include_examples 'successful weather request', 'weather_historical_avg/success',
                       '/api/v1/weather/historical_avg', 'avg_temperature_celsius', 24.0
    end

    describe 'GET /api/v1/weather/by_time' do
      it do
        VCR.use_cassette('weather_by_time/success') do
          get '/api/v1/weather/by_time', params: { timestamp: }

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(
            'temperature_celsius' => '24.0'
          )
        end
      end
    end
  end
end
