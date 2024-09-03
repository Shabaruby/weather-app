# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Weather API', type: :request do

  path '/api/v1/weather/current' do
    get 'Get the current temperature' do
      tags 'Weather'
      produces 'application/json'

      response '200', 'successful' do
        let(:temperature_celsius) { '20.0' }

        before do
          allow_any_instance_of(WeatherService).to receive(:fetch_weather_data).and_return({ temperature_celsius: temperature_celsius })
        end

        run_test!
      end
    end
  end

  path '/api/v1/weather/historical' do
    get 'Get hourly temperatures for the last 24 hours' do
      tags 'Weather'
      produces 'application/json'

      response '200', 'successful' do
        let(:hourly_temperatures) do
          [
            { recorded_at: 1.hour.ago.iso8601, temperature_celsius: 15.0 },
            { recorded_at: 2.hours.ago.iso8601, temperature_celsius: 16.0 },
            { recorded_at: 3.hours.ago.iso8601, temperature_celsius: 14.5 }
          ]
        end

        before do
          allow_any_instance_of(WeatherService).to receive(:fetch_historical_data).and_return({ hourly_temperatures: hourly_temperatures })
        end

        run_test!
      end
    end
  end

  path '/api/v1/weather/historical_max' do
    get 'Get maximum temperature for the last 24 hours' do
      tags 'Weather'
      produces 'application/json'

      response '200', 'successful' do
        let(:max_temperature_celsius) { 16.0 }

        before do
          allow_any_instance_of(WeatherService).to receive(:max_temperature).and_return(max_temperature_celsius)
        end

        run_test!
      end
    end
  end

  path '/api/v1/weather/historical_min' do
    get 'Get minimum temperature for the last 24 hours' do
      tags 'Weather'
      produces 'application/json'
      response '200', 'successful' do
        let(:min_temperature_celsius) { 16.0 }

        before do
          allow_any_instance_of(WeatherService).to receive(:min_temperature).and_return(min_temperature_celsius)
        end

        run_test!
      end
    end
  end

  path '/api/v1/weather/historical_avg' do
    get 'Get average temperature for the last 24 hours' do
      tags 'Weather'
      produces 'application/json'

      response '200', 'successful' do
        let(:avg_temperature_celsius) { 16.0 }

        before do
          allow_any_instance_of(WeatherService).to receive(:avg_temperature).and_return(avg_temperature_celsius)
        end

        run_test!
      end
    end
  end

  path '/api/v1/weather/by_time' do
    get 'Get temperature closest to the given timestamp' do
      tags 'Weather'
      produces 'application/json'
      parameter name: :timestamp, in: :query, type: :integer, description: 'Unix timestamp', required: true


      response '200', 'successful' do
        let(:timestamp) { 1.hour.ago.to_i }
        let(:temperature_celsius) { 15.0 }

        before do
          allow_any_instance_of(WeatherService).to receive(:temperature_by_time).with(timestamp).and_return(temperature_celsius)
        end

        run_test!
      end
    end
  end

  path '/api/v1/health' do
    get 'Get backend status' do
      tags 'Health'
      produces 'application/json'

      response '200', 'successful' do
        run_test!
      end
    end
  end
end
