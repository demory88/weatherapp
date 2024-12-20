require 'rails_helper'

describe WeatherController, type: :request do
  describe 'GET /index' do
    it 'responds with ok status when no params are supplied' do
      get root_path

      expect(response).to have_http_status :ok
    end

    it 'responds with current weather for the supplied address' do
      get root_path address: "Chillicothe, IL"

      expect(response.body).to include("Current Weather for Chillicothe, IL")
    end
  end
end
