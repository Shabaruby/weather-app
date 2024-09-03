# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  let(:service) { described_class.new }

  describe '#call' do
    subject { service.call }

    before do
      allow(service).to receive_messages(find_temperature_in_db: db_temperature, fetch_weather_data: api_weather_data)
      allow(service).to receive(:save_temperature)
    end

    context 'when temperature is found in the database' do
      let(:db_temperature) { { temperature_celsius: 20.0 } }
      let(:api_weather_data) { { temperature_celsius: 25.0 } }

      it { is_expected.to eq(temperature_celsius: 20.0) }
    end

    context 'when temperature is not found in the database' do
      let(:db_temperature) { nil }
      let(:api_weather_data) { { temperature_celsius: 25.0 } }

      it do
        is_expected.to eq(temperature_celsius: 25.0)
        expect(service).to have_received(:save_temperature).with(25.0)
      end
    end
  end

  describe '#fetch_historical_data' do
    let(:historical_weather_data) do
      [
        { 'LocalObservationDateTime' => '2024-09-01T10:00:00', 'Temperature' => { 'Metric' => { 'Value' => '10.0' } } },
        { 'LocalObservationDateTime' => '2024-09-01T11:00:00', 'Temperature' => { 'Metric' => { 'Value' => '12.0' } } }
      ]
    end

    before do
      allow(service).to receive(:historical_uri).and_return(URI('http://example.com'))
      allow(Net::HTTP).to receive_message_chain(:get_response, :body).and_return(historical_weather_data.to_json)
    end

    it do
      expect(service.fetch_historical_data[:hourly_temperatures].first[:temperature_celsius]).to eq(10.0)
      expect(service.fetch_historical_data[:hourly_temperatures].second[:temperature_celsius]).to eq(12.0)
    end
  end

  describe '#fetch_and_save_historical_data_sync' do
    let(:historical_weather_data) do
      [
        { 'LocalObservationDateTime' => '2024-09-01T10:00:00', 'Temperature' => { 'Metric' => { 'Value' => '10.0' } } },
        { 'LocalObservationDateTime' => '2024-09-01T11:00:00', 'Temperature' => { 'Metric' => { 'Value' => '12.0' } } }
      ]
    end

    before do
      allow(service).to receive(:fetch_historical_data).and_return(
        { hourly_temperatures: historical_weather_data.map do |entry|
          {
            recorded_at: Time.zone.parse(entry['LocalObservationDateTime']),
            temperature_celsius: entry.dig('Temperature', 'Metric', 'Value').to_f
          }
        end }
      )
      allow(service).to receive(:save_historical_temperature)
    end

    it do
      service.fetch_and_save_historical_data_sync
      expect(service).to have_received(:save_historical_temperature).with(10.0, Time.zone.parse('2024-09-01T10:00:00'))
      expect(service).to have_received(:save_historical_temperature).with(12.0, Time.zone.parse('2024-09-01T11:00:00'))
    end
  end

  describe '#historical' do
    let(:historical_data_from_db) do
      [
        { temperature_celsius: 20.0, time: 1.hour.ago }
      ]
    end

    before do
      allow(service).to receive(:fetch_historical_data_from_db).and_return(historical_data_from_db)
      allow(service).to receive(:fetch_and_save_historical_data)
    end

    it { expect(service.historical[:hourly_temperatures].first[:temperature_celsius]).to eq(20.0) }
  end

  describe '#max_temperature' do
    subject { service.max_temperature }

    before do
      allow(HistoricalTemperature).to receive_message_chain(:order, :limit, :pluck, :max).and_return(30.0)
    end

    it { is_expected.to eq(30.0) }
  end

  describe '#min_temperature' do
    subject { service.min_temperature }

    before do
      allow(HistoricalTemperature).to receive_message_chain(:order, :limit, :pluck, :min).and_return(20.0)
    end

    it { is_expected.to eq(20.0) }
  end

  describe '#avg_temperature' do
    subject { service.avg_temperature }

    before do
      allow(HistoricalTemperature).to receive_message_chain(:order, :limit, :average).and_return(25.0)
    end

    it { is_expected.to eq(25.0) }
  end

  describe '#temperature_by_time' do
    subject { service.temperature_by_time(timestamp) }

    let(:timestamp) { Time.now.to_i }

    before do
      allow(HistoricalTemperature).to receive_message_chain(:order, :first, :temperature_celsius).and_return(15.0)
    end

    it { is_expected.to eq(15.0) }
  end
end
