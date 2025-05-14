require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe 'POST /api/v1/signup' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            name: 'Test User',
            email: 'new@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'creates a new user' do
        expect {
          post '/api/v1/signup', params: valid_params
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json_response['token']).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            name: '',
            email: 'invalid-email',
            password: 'short'
          }
        }
      end

      it 'returns validation errors' do
        post '/api/v1/signup', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'POST /api/v1/login' do
    context 'with valid credentials' do
      let(:valid_params) do
        {
          email: user.email,
          password: 'password123'
        }
      end

      it 'returns authentication token' do
        post '/api/v1/login', params: valid_params
        expect(response).to have_http_status(:ok)
        expect(json_response['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      let(:invalid_params) do
        {
          email: user.email,
          password: 'wrong_password'
        }
      end

      it 'returns authentication error' do
        post '/api/v1/login', params: invalid_params
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid email or password')
      end
    end
  end
end
