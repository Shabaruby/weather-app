# frozen_string_literal: true

module Request
  # API
  class API < Grape::API
    version 'v1'
    format :json
    prefix :api

    helpers do
      def handle_result(result, entity)
        if result.success?
          present result['result'], with: entity
        else
          error!(result['result']['error'], result['error_status'])
        end
      end
    end

    resource :weather do
      desc 'Текущая погода'
      get :current do
        result = Weather::Operations::Current.call

        handle_result(result, Entities::CurrentWeatherEntity)
      end

      desc 'Почасовая температура за последние 24 часа'
      get :historical do
        result = Weather::Operations::Historical.call

        handle_result(result, Entities::HistoricalWeatherEntity)
      end

      desc 'Максимальная температура за последние 24 часа'
      get :historical_max do
        result = Weather::Operations::HistoricalMax.call

        handle_result(result, Entities::HistoricalMaxWeatherEntity)
      end

      desc 'Минимальная температура за последние 24 часа'
      get :historical_min do
        result = Weather::Operations::HistoricalMin.call

        handle_result(result, Entities::HistoricalMinWeatherEntity)
      end

      desc 'Средняя температура за последние 24 часа'
      get :historical_avg do
        result = Weather::Operations::HistoricalAvg.call

        handle_result(result, Entities::HistoricalAvgWeatherEntity)
      end

      desc 'Температура ближайшая к переданному времени'
      params do
        requires :timestamp, type: Integer, desc: 'Unix timestamp'
      end
      get :by_time do
        result = Weather::Operations::ByTime.call(timestamp: params[:timestamp])

        handle_result(result, Entities::ByTimeWeatherEntity)
      end
    end

    resource :health do
      desc 'Статус бекенда'
      get do
        { status: 'OK' }
      end
    end
  end
end
