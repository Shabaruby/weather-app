# frozen_string_literal: true

# Service for fetching and saving weather data
class WeatherService
  BASE_URL = 'http://dataservice.accuweather.com'
  API_KEY = ENV.fetch('API_KEY', nil)
  LOCATION_KEY = ENV.fetch('LOCATION_KEY', nil)

  def call
    temperature = find_temperature_in_db
    return temperature if temperature

    weather_data = fetch_weather_data
    save_temperature(weather_data[:temperature_celsius])
    weather_data
  end

  def fetch_historical_data
    response = Net::HTTP.get_response(historical_uri)
    weather_data = JSON.parse(response.body)
    parse_historical_data(weather_data)
  end

  def fetch_and_save_historical_data
    HistoricalJob.perform_later
  end

  def historical
    historical_data_from_db = fetch_historical_data_from_db

    if historical_data_from_db.empty?
      fetch_and_save_historical_data_sync
      historical_data_from_db = fetch_historical_data_from_db
    end

    format_historical_data(historical_data_from_db)
  end

  def max_temperature
    temperature_scope.pluck(:temperature_celsius).max
  end

  def min_temperature
    temperature_scope.pluck(:temperature_celsius).min
  end

  def avg_temperature
    temperature_scope.average(:temperature_celsius).to_f.round(2)
  end

  def temperature_by_time(timestamp)
    nearest_entry = find_nearest_temperature_record(timestamp)
    nearest_entry&.temperature_celsius
  end

  def fetch_and_save_historical_data_sync
    weather_data = fetch_historical_data
    weather_data[:hourly_temperatures].each do |entry|
      save_historical_temperature(entry[:temperature_celsius], entry[:recorded_at])
    end
  end

  private

  def find_temperature_in_db
    recent_record = Temperature.where('recorded_at >= ?', 2.minutes.ago).order(recorded_at: :desc).first
    return unless recent_record

    { temperature_celsius: recent_record.temperature_celsius }
  end

  def fetch_weather_data
    response = Net::HTTP.get_response(uri)
    weather_data = JSON.parse(response.body)

    first_entry = weather_data.is_a?(Array) ? weather_data.first : weather_data
    temperature_celsius = first_entry.dig('Temperature', 'Metric', 'Value') if first_entry

    { temperature_celsius: }
  end

  def save_temperature(temperature_celsius)
    Temperature.create!(
      temperature_celsius:,
      recorded_at: Time.current
    )
  end

  def fetch_historical_data_from_db
    temperature_scope.select(:temperature_celsius, :recorded_at).map do |record|
      { temperature_celsius: record.temperature_celsius, recorded_at: record.recorded_at }
    end
  end

  def save_historical_temperature(temperature_celsius, recorded_at)
    HistoricalTemperature.create!(
      temperature_celsius:,
      recorded_at:
    )
  end

  def parse_historical_data(weather_data)
    {
      hourly_temperatures: weather_data.map do |entry|
        {
          recorded_at: Time.parse(entry['LocalObservationDateTime']),
          temperature_celsius: entry.dig('Temperature', 'Metric', 'Value').to_f
        }
      end
    }
  end

  def format_historical_data(data)
    { hourly_temperatures: data }
  end

  def temperature_scope
    HistoricalTemperature.order(recorded_at: :desc).limit(24)
  end

  def find_nearest_temperature_record(timestamp)
    HistoricalTemperature.order(Arel.sql("ABS(EXTRACT(EPOCH FROM recorded_at) - #{timestamp})")).first
  end

  def uri
    URI("#{BASE_URL}/currentconditions/v1/#{LOCATION_KEY}")
      .tap { |u| u.query = URI.encode_www_form(apikey: API_KEY) }
  end

  def historical_uri
    URI("#{BASE_URL}/currentconditions/v1/#{LOCATION_KEY}/historical/24")
      .tap { |u| u.query = URI.encode_www_form(apikey: API_KEY, details: 'true') }
  end
end
