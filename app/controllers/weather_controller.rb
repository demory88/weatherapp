class WeatherController < ApplicationController
  def index
    # check if the user has submitted a request, if not we'll serve them the blank index page
    if params[:address].present?
      @cached_weather = false
      @api_error = nil
      @forecast = nil

      # first we'll check to see if we have the search cached
      if Rails.cache.exist?(params[:address])
        @forecast = Rails.cache.read(params[:address])
        @cached_weather = true
      else
        # converts address/zip to lat&lon
        location = Geocoder.search(params[:address])
        # proceed only if we've been able to geocode the user's location
        if location.present?
          # create our weather API client for requests
          client = OpenWeather::Client.new(
            api_key: Rails.application.credentials.open_weather_key
          )
          # fetch weather report and save it to the cache
          @forecast = client.one_call(lat: location.first.coordinates[0], lon: location.first.coordinates[1], exclude: ['minutely', 'hourly'])
          # for a scalable implementation we might switch to a more robust solution, but for this example the basic Rails cache will suffice
          Rails.cache.write(params[:address], @forecast, expires_in: 30.minutes)
        else
          @api_error = "We couldn't find that location, please check the spelling and try again."
        end
      end
    end
  end
end
