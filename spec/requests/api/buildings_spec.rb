require 'rails_helper'

RSpec.describe Api::V1::ClientsController, type: :request do
  describe 'GET /api/v1/buildings?page=1' do
    context 'when the request is successful' do
      let!(:client) { create(:client, :with_buildings_and_custom_fields) }

      before do
        get '/api/v1/buildings?page=1'
      end

      let(:json_response) { JSON.parse(response.body) }

      it 'returns success status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all clients' do
        expect(json_response['buildings']).to be_an(Array)
        expect(json_response['total_pages']).to be >= 0
      end
    end
  end
end
