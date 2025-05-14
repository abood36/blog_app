require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:tag) { create(:tag, name: 'technology') }

  describe 'GET /api/v1/posts' do
    before do
      create_list(:post, 3, user: user, tags: [tag])
    end

    it 'returns all posts' do
      get '/api/v1/posts', headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response['posts'].length).to eq(3)
    end

    it 'returns posts with tags' do
      get '/api/v1/posts', headers: headers
      expect(json_response['posts'].first['tags']).to be_present
    end
  end

  describe 'POST /api/v1/posts' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          post: {
            title: 'Test Post',
            body: 'This is a test post',
            tag_ids: [tag.id]
          }
        }
      end

      it 'creates a new post' do
        expect {
          post '/api/v1/posts', params: valid_params, headers: headers
        }.to change(Post, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it 'schedules post deletion' do
        expect {
          post '/api/v1/posts', params: valid_params, headers: headers
        }.to change(PostDeletionJob.jobs, :size).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          post: {
            title: '',
            body: '',
            tag_ids: []
          }
        }
      end

      it 'returns validation errors' do
        post '/api/v1/posts', params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'PUT /api/v1/posts/:id' do
    let(:post) { create(:post, user: user, tags: [tag]) }

    context 'when user is the author' do
      let(:update_params) do
        {
          post: {
            title: 'Updated Title',
            body: 'Updated body'
          }
        }
      end

      it 'updates the post' do
        put "/api/v1/posts/#{post.id}", params: update_params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(post.reload.title).to eq('Updated Title')
      end
    end

    context 'when user is not the author' do
      let(:other_user) { create(:user) }
      let(:other_token) { generate_token(other_user) }
      let(:other_headers) { { 'Authorization' => "Bearer #{other_token}" } }

      it 'returns unauthorized error' do
        put "/api/v1/posts/#{post.id}", params: { post: { title: 'New Title' } }, headers: other_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/posts/:id' do
    let!(:post) { create(:post, user: user, tags: [tag]) }

    context 'when user is the author' do
      it 'deletes the post' do
        expect {
          delete "/api/v1/posts/#{post.id}", headers: headers
        }.to change(Post, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not the author' do
      let(:other_user) { create(:user) }
      let(:other_token) { generate_token(other_user) }
      let(:other_headers) { { 'Authorization' => "Bearer #{other_token}" } }

      it 'returns unauthorized error' do
        delete "/api/v1/posts/#{post.id}", headers: other_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
