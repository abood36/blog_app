require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:post) { create(:post, user: create(:user)) }

  describe 'POST /api/v1/posts/:post_id/comments' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          comment: {
            content: 'This is a test comment'
          }
        }
      end

      it 'creates a new comment' do
        expect {
          post "/api/v1/posts/#{post.id}/comments", params: valid_params, headers: headers
        }.to change(Comment, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it 'schedules notification job' do
        expect {
          post "/api/v1/posts/#{post.id}/comments", params: valid_params, headers: headers
        }.to change(NotificationJob.jobs, :size).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          comment: {
            content: ''
          }
        }
      end

      it 'returns validation errors' do
        post "/api/v1/posts/#{post.id}/comments", params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'PUT /api/v1/posts/:post_id/comments/:id' do
    let(:comment) { create(:comment, user: user, post: post) }

    context 'when user is the author' do
      let(:update_params) do
        {
          comment: {
            content: 'Updated comment'
          }
        }
      end

      it 'updates the comment' do
        put "/api/v1/posts/#{post.id}/comments/#{comment.id}", params: update_params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(comment.reload.content).to eq('Updated comment')
      end
    end

    context 'when user is not the author' do
      let(:other_user) { create(:user) }
      let(:other_token) { generate_token(other_user) }
      let(:other_headers) { { 'Authorization' => "Bearer #{other_token}" } }

      it 'returns unauthorized error' do
        put "/api/v1/posts/#{post.id}/comments/#{comment.id}", 
            params: { comment: { content: 'New content' } }, 
            headers: other_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/posts/:post_id/comments/:id' do
    let!(:comment) { create(:comment, user: user, post: post) }

    context 'when user is the author' do
      it 'deletes the comment' do
        expect {
          delete "/api/v1/posts/#{post.id}/comments/#{comment.id}", headers: headers
        }.to change(Comment, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not the author' do
      let(:other_user) { create(:user) }
      let(:other_token) { generate_token(other_user) }
      let(:other_headers) { { 'Authorization' => "Bearer #{other_token}" } }

      it 'returns unauthorized error' do
        delete "/api/v1/posts/#{post.id}/comments/#{comment.id}", headers: other_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
