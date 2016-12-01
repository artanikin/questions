require 'rails_helper'

describe 'Profiles API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response).to have_http_status 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '123456'
        expect(response).to have_http_status 401
      end
    end
  end
end
